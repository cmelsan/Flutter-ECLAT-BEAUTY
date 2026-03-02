-- ============================================================
-- FIX: request_return RPC debe marcar order_items.return_status = 'requested'
-- 
-- PROBLEMA: La función request_return solo actualizaba orders.status 
-- a 'return_requested' pero NO marcaba los items individuales con
-- return_status = 'requested'. Esto causaba:
--   1. refundAmountCents = 0 en la pantalla de devoluciones
--   2. admin_process_return no encontraba items para procesar
--
-- EJECUTAR EN SUPABASE SQL EDITOR
-- ============================================================

CREATE OR REPLACE FUNCTION request_return(
    p_order_id UUID,
    p_reason TEXT,
    p_item_ids UUID[] DEFAULT NULL  -- NULL = devolver todos los items
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_order RECORD;
    v_items_updated INT := 0;
    v_return_deadline INTERVAL := INTERVAL '30 days';
BEGIN
    -- 1. Validar que el pedido existe
    SELECT * INTO v_order FROM orders WHERE id = p_order_id;

    IF NOT FOUND THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Pedido no encontrado',
            'code', 'ORDER_NOT_FOUND'
        );
    END IF;

    -- 2. Validar estado: debe estar 'delivered' para solicitar devolución
    IF v_order.status != 'delivered' THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Solo se pueden devolver pedidos entregados',
            'current_status', v_order.status,
            'code', 'INVALID_ORDER_STATUS'
        );
    END IF;

    -- 3. Validar plazo de devolución (30 días desde la entrega)
    IF v_order.delivered_at IS NOT NULL 
       AND (NOW() - v_order.delivered_at) > v_return_deadline THEN
        RETURN json_build_object(
            'success', false,
            'error', 'El plazo de devolución ha expirado (30 días)',
            'code', 'RETURN_DEADLINE_EXPIRED'
        );
    END IF;

    BEGIN
        -- 4. Marcar items individuales con return_status = 'requested'
        IF p_item_ids IS NOT NULL AND array_length(p_item_ids, 1) > 0 THEN
            -- Devolución parcial: solo los items seleccionados
            UPDATE order_items
            SET return_status = 'requested',
                return_reason = p_reason
            WHERE order_id = p_order_id
              AND id = ANY(p_item_ids)
              AND (return_status IS NULL OR return_status = 'rejected');
            
            GET DIAGNOSTICS v_items_updated = ROW_COUNT;
        ELSE
            -- Devolución total: todos los items del pedido
            UPDATE order_items
            SET return_status = 'requested',
                return_reason = p_reason
            WHERE order_id = p_order_id
              AND (return_status IS NULL OR return_status = 'rejected');
            
            GET DIAGNOSTICS v_items_updated = ROW_COUNT;
        END IF;

        IF v_items_updated = 0 THEN
            RETURN json_build_object(
                'success', false,
                'error', 'No hay items disponibles para devolver',
                'code', 'NO_RETURNABLE_ITEMS'
            );
        END IF;

        -- 5. Actualizar estado del pedido
        UPDATE orders
        SET status = 'return_requested',
            return_reason = p_reason,
            return_initiated_at = NOW(),
            updated_at = NOW()
        WHERE id = p_order_id;

        -- 6. Insertar historial
        INSERT INTO order_status_history (
            order_id,
            from_status,
            to_status,
            changed_by,
            changed_by_type,
            notes,
            created_at
        ) VALUES (
            p_order_id,
            v_order.status,
            'return_requested',
            auth.uid(),
            'customer',
            'Motivo: ' || p_reason,
            NOW()
        );

        RETURN json_build_object(
            'success', true,
            'message', 'Solicitud de devolución registrada',
            'order_id', p_order_id,
            'items_updated', v_items_updated,
            'code', 'RETURN_REQUESTED_SUCCESS'
        );

    EXCEPTION WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', SQLERRM,
            'code', 'TRANSACTION_ERROR'
        );
    END;
END;
$$;

-- ============================================================
-- TAMBIÉN: Asegurarse de que fix_process_return_stock.sql está desplegado
-- La versión original de admin_process_return no marca items como 'refunded'
-- y no calcula refund_amount. Verificar con:
-- ============================================================
-- SELECT proname, prosecdef, prosrc 
-- FROM pg_proc 
-- WHERE proname = 'admin_process_return';
-- 
-- Si la función NO contiene "return_status = 'refunded'", ejecutar
-- fix_process_return_stock.sql para actualizar.
-- ============================================================

-- Permisos
GRANT EXECUTE ON FUNCTION request_return(UUID, TEXT, UUID[]) TO authenticated;

-- Verificar
SELECT proname, prosecdef FROM pg_proc WHERE proname = 'request_return';
