# SYSTEM DESIGN SPECIFICATIONS

___
> Target System: Integrated Human Resource Management Information System (IHRMIS)<br>
> Document Version: 0.00
___

## Introduction

This document outlines the design specifications of the target system IHRMIS. It includes information on the system's requirements, architecture, and database design. It may also include other pertinent information that may eventually prove to be useful in the maintenance, updating, and troubleshooting of the information system.

## System Architecture

In general, the IHRMIS shall be implemented as a web-based application/information system. Users may access the information system from browsers in any client device with network access. The web server accepts requests from the user and accesses data or files from the appropriate server. After processing the request, the web server then responds to client devices with either the requested resources or meaningful messages that reflect the result of requested actions.

![IHRMIS: Web System Architecture](./Design%20Diagrams/Web_System_Architecture.png "IHRMIS: Web System Architecture")

The IHRMIS shall have two main interfaces:

* The **main interface** shall be used by the HRMO and other personnel in day-to-day human resource management (HRM) operations. It will provide access to management-level features.
* The **self-service portal** shall be accessible to all users, which includes job applicants and employees. It may also provide access to special features depending on user role.

The main interface, in turn, shall provide access to HRM features and functions, which include, among others, employee records management, leave management, organization management, RSP (recruitment, selection, and placement) features, performance management, learning and development features, and rewards management.

### Platform

The IHRMIS shall leverage both the Node.JS and MySQL platforms for implementation of its web service and database system, respectively. As such, all other system requirements shall be based on the recommended system requirements for these two platforms, on top of the anticipated system overhead that may be realized during the actual operation of the information system.

#### Dependencies and System Requirements

The information system does not require a specific operating system. However, it needs several hardware and software components to allow it to function as a web-based service.

##### Node.JS/NPM Modules

A Node.JS LTS version should be installed. Likewise, specific non-built-in Node.JS/NPM modules are required for IHRMIS to operate:

* **ExpressJS**
* **_**

This is a running list and may be updated when dependencies change.

##### Other Software

The IHRMIS will require the latest LTS version of MySQL Server for the database functionality.

##### Hardware

Minimum system requirements:

* **Processor:** 2 vCPUs (or physical cores)
* **Memory (RAM):** 4 GB
* **Disk Space:** 20 GB SSD
* **Operating System:** Any operating system that supports Node.JS and MySQL
* **Network:** 100 Mbps minimum

Recommended system requirements:

* **Processor:** 4 vCPUs or better
* **Memory (RAM):** 8 GB+
* **Disk Space:** 50-100 GB SSD
* **Operating System:** Any Linux server distribution
* **Network:** 1 Gbps or unmetered

### Design Patterns

![IHRMIS: MVC Design Pattern](./Design%20Diagrams/Design_Pattern-MVC.png "IHRMIS: MVC Design Pattern")

The project will mostly be using the Model-View-Controller design pattern for the system architecture. System components will exchange data through RESTful APIs to ensure a statelessness among the components. Authentication will be handled through an open authentication framework and the generation and use of a JWT.

#### Route Endpoints

Route endpoints shall be categorized into the following types:

* **API endpoint** - will be used in CRUD (create, retrieve, update, restore) operations; endpoint shall be of the following pattern: <br>```[BASE_URL]/ihrmis/api/vX.XX/[DATANAME]``` where *vX.XX* shall denote the API version
* **Resource endpoint** - will be used to serve images, files, or streams of data; endpoint shall be of the following pattern: <br>```[BASE_URL]/ihrmis/res/[RESOURCE_ID]```
* **User interface endpoint** - the VIEW component; will be used to serve and render web pages using HTML and CSS; may use any other directory under ```[BASE_URL]/ihrmis/```

To fully implement the principles of RESTful API design, the web API shall use endpoint nouns that directly mirror many of the tables and views in the database.

## Database Design

Data storage shall be handled by a MySQL database server. As the web API shall be designed according to RESTful principles, the database design shall also adhere to CRUD principles. Refer to the following list for the tables, views, and API endpoints that will be exposed by the web API.

* Person
* 
* 

To improve database performance, an optional Redis cache may be configured.

## Logging Features

There will be two types of IHRMIS logs: database history logs and system logs. Database logs are stored in the database and capture database-related operations, particularly CRUD operations. These may be useful in data security and policy compliance audits. On the other hand, system logs are stored as text files and capture system activities and exceptions encountered during the system's operation. These logs may prove to be useful in the maintenance and troubleshooting of the system.
