# Pizzería Don Piccolo — Base de datos

## Descripción
Proyecto que modela y automatiza la gestión de pedidos, domicilios, reparto y stock para Pizzería Don Piccolo en MySQL. Incluye tablas, funciones, procedimientos, triggers, vistas y consultas de reporte.

## Estructura del proyecto
/pizzeria-don-piccolo/
 ├── database.sql         -- Script de creación de tablas
 ├── inserts.sql          -- Datos de ejemplo
 ├── funciones.sql        -- Funciones y procedimientos
 ├── triggers.sql         -- Triggers automáticos
 ├── vistas.sql           -- Vistas de reportes
 ├── consultas.sql        -- Consultas requeridas
 └── README.md

## Notas sobre la implementación
- El campo `pizza.precio` **incluye IVA** (19%).  
- Las funciones `calcular_total_pedido`, `calcular_iva_pedido` y `calcular_subtotal_pedido` se usan para calcular totales y mantener consistencia.  
- Existen triggers que:
  - validan stock antes de insertar una pizza en un pedido,
  - descuentan stock al crear un detalle de pedido,
  - reponen stock si se elimina un detalle,
  - registran cambios de precio en `historial_precios`,
  - recalculan totales en `pedido` cuando se modifica `detalle_pedido`,
  - marcan repartidor disponible y llaman al procedimiento `marcar_pedido_entregado` cuando se registra `hora_entrega` en `domicilio`.

## Instrucciones de ejecución
1. Abrir MySQL Workbench o cliente MySQL.
2. Ejecutar `database.sql`.
3. Ejecutar `inserts.sql`.
4. Ejecutar `funciones.sql`.
5. Ejecutar `triggers.sql`.
6. Ejecutar `vistas.sql`.
7. Ejecutar `consultas.sql` (opcional, para probar las consultas).

> Ejecuta en ese orden para evitar errores por dependencias (funciones/triggers/procedures).

## Ejemplos de consultas
- `SELECT * FROM vista_resumen_pedidos_cliente;`  
- `SELECT * FROM vista_desempeno_repartidor;`  
- `SELECT * FROM vista_stock_bajo;`  
- `CALL marcar_pedido_entregado(5);`  

## Consideraciones y mejoras futuras
- Agregar logs de auditoría más completos (usuario, motivo) al historial de precios.  
- Añadir control de lotes y fechas de vencimiento para ingredientes.  
- Implementar proceso de reposición automática (procedimiento) para cuando stock_actual <= stock_minimo.  
- Añadir tests unitarios y datos de performance para stress testing.

---

