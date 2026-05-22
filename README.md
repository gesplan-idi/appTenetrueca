# App Móvil Android en Flutter - Sistema de Lectura y Gestión

¡Bienvenido al repositorio del proyecto! Esta es una aplicación móvil desarrollada en **Flutter** para la plataforma Android. Cuenta con un sistema completo de autenticación y una arquitectura de pantalla única dinámica gestionada a través de un `NavigationDrawer` y un acceso rápido en la barra inferior (`BottomNavigationBar`).

## 🚀 Características Principales

*   **Flujo de Autenticación Completo:** Login, registro de usuarios y recuperación de contraseña.
*   **Acceso Centralizado:** Pantalla principal por defecto configurada como un Lector de códigos/QR.
*   **Navegación Fluida:** Menú lateral desplegable (`NavigationDrawer`) con 6 opciones de gestión que no recargan la interfaz completa.
*   **Botón de Acción Rápida:** Acceso inmediato al lector desde la barra inferior en cualquier momento.

---

## 🗺️ Diagrama de Flujo de la Aplicación

El siguiente diagrama detalla la lógica de navegación y el control de sesiones (`Auth Gate`) implementado en la aplicación:

```text
                                [ INICIO DE LA APP ]
                                         │
                                         ▼
                       ¿Existe una sesión activa del usuario?
                                         │
                    ┌────────────────────┴────────────────────┐
                 NO │                                         │ SÍ
                    ▼                                         ▼
      ┌───────────────────────────┐             ┌───────────────────────────┐
      │  [ FLUJO DE AUTENTICACIÓN ] │             │   [ PANTALLA PRINCIPAL ]  │
      └─────────────┬─────────────┘             └─────────────┬─────────────┘
                    │                                         │
    ┌───────────────┼───────────────┐                         ▼
    ▼               ▼               ▼           ┌───────────────────────────┐
┌───────┐       ┌────────┐      ┌──────────┐    │ VISTA ACTIVA POR DEFECTO: │
│ Login │ ──►   │ Register│     │ Recup.   │    │       LectorScreen        │
└───────┘       └────────┘      └──────────┘    └─────────────┬─────────────┘
    │                                                         │
    └─► [Éxito] ──────────────────────────────────────────────┤
                                                              │
                                    ┌─────────────────────────┴─────────────────────────┐
                                    ▼                                                   ▼
                     ┌─────────────────────────────┐                     ┌─────────────────────────────┐
                     │   Usuario abre el DRAWER    │                     │  Usuario presiona BOTÓMBAR  │
                     └──────────────┬──────────────┘                     └──────────────┬──────────────┘
                                    │                                                   │
                                    ▼                                                   ▼
                     Evalúa el ítem seleccionado:                                 Forzar regreso a:
                     ├─► "Objetos"       -► body = ObjetosScreen()                 LectorScreen()
                     ├─► "Historial"     -► body = HistorialScreen()
                     ├─► "Ajustes"       -► body = AjustesScreen()
                     ├─► "Usuarios"      -► body = UsuariosScreen()
                     ├─► "Subir Producto"-► body = SubirProductoScreen()
                     └─► "Salir"         -► Limpiar Token -► Ir a Login
