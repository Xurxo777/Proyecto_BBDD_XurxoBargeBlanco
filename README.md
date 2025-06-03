# 🏭 Base de Datos: Empresa de Automatización Industrial

## Descrición

Este proxecto consiste no deseño e implementación dunha base de datos relacional para unha empresa ficticia dedicada á automatización industrial. Desenvolveuse como traballo final da materia de Bases de Datos no ciclo de 1º DAM (curso 2024/25). A base de datos permite xestionar de forma eficaz clientes, proxectos, empregados, máquinas, compoñentes, incidencias, formacións, certificacións, pedidos e máis.

---

## 📑 Táboa de Contidos

- [Requisitos](#requisitos)  
- [Fases do Proxecto](#fases-do-proxecto)  
  - [1. Recolección de Requisitos](#1-recolección-de-requisitos)  
  - [2. Deseño Conceptual](#2-deseño-conceptual)  
  - [3. Deseño Relacional e Normalización](#3-deseño-relacional-e-normalización)  
  - [4. Implementación SQL](#4-implementación-sql)  
  - [5. Funcións, Procedementos e Triggers](#5-funcións-procedementos-e-triggers)  
  - [6. Probas e Validación](#6-probas-e-validación)  
- [Estrutura do Repositorio](#estrutura-do-repositorio)  
- [Instalación e Uso](#instalación-e-uso)  
- [Melloras Futuras](#melloras-futuras)  
- [Licenza](#licenza)

---

## 📋 Requisitos

- MySQL 8.0+
- MySQL Workbench (opcional)
- Git
- SO: Windows, Linux ou macOS

---

## 🔄 Fases do Proxecto

### 1. Recolección de Requisitos
- Identificación das necesidades de xestión dunha empresa de automatización industrial.
- Definición de entidades clave como clientes, proxectos, empregados, máquinas, compoñentes, incidencias, etc.

### 2. Deseño Conceptual
- Creación dun modelo entidade-relación completo.

### 3. Deseño Relacional e Normalización
- Conversión a modelo relacional.
- Normalización ata 3FN.
- Identificación de claves primarias, foráneas e relacións N:M.

### 4. Implementación SQL
- Scripts de creación da base de datos.
- Carga inicial de datos representativos.
- Consultas de negocio (JOIN, agregacións, subconsultas).

### 5. Funcións, Procedementos e Triggers
- Funcións: cálculo de antigüidade, nome completo, resumo de empregados.
- Procedementos: inserción de empregados, actualización de contacto, eliminación con backup.
- Triggers: validacións, rexistro de cambios, restricións lóxicas.

### 6. Probas e Validación
- Altas, baixas e modificacións.
- Comprobación de integridade referencial e funcional.
- Execución de consultas complexas para extracción de información útil.
- Simulacións con erros controlados.

---

## 🗂️ Estrutura do Repositorio

