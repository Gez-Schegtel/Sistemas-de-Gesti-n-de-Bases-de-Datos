---
title: ""
author: ""
date: ""
geometry: margin=1in
colorlinks: true
header-includes:
	- \usepackage{fvextra}
	- \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
	- \usepackage{graphicx}
	- \setkeys{Gin}{width=0.75\textwidth}
	- \usepackage{float}
	- \floatplacement{figure}{H}
---

# Transacciones

ACID:

* Atomicidad

* Consistencia

* Aislación

* Durabilidad

Las transacciones tienen que ser lo más pequeñas posibles. Esto es así porque su ejecución puede afectar la performance de la base de datos (por los bloqueos, por ejemplo).
