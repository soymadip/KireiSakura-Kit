---
title: 1. Terminologies
forVersion: 0.6.5
icon: book-a
---
<h1 align="center">Temninology</h1>
<br><p align="center">1st, let's understand some terms used throughout the Docs.</p>

<br>

## Methods
**Methods** are the functions exposed by [[terminology#Modules|Modules.]] 
They are the primary API for interacting with KireiSakura-Kit.


---
## Modules
 **Modules** are self-contained scripts that store methods. Each module performs a specific task and can be sourced as needed.
 
 There are 3 types are modules:-
### 1. Core modules
These are essential components of the KireiSakura-Kit providing the foundational functionality required for the framework to operate. 

 These are automatically loaded at start. 
 
### 2. Plugin modules
These are optional modules used to extend the functionality of the framework.

These are required to be [[init#3. Loading modules|loaded]] implicitly using `kimport` function.

### 3.  User modules
These are similar to [[terminology#2. Plugin modules|plugin modules]] except these are designed  & implemented by the user.

>[!info]
>**Create user modules** by making a directory called `modules` in the project root.
>```dir
><PROJECT_ROOT>
>   |-main.sh
>   |-modules/
>       |
>       |-module1.sh
>       |-module2.sh
>```


---

>[!success] Done
> Now that you know  the terms, head to [[init#^6c74f6|Initialization]] to start sourcing Kit.
