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
* The **self-service portal** shall be accessible to all users, which includes job applicants and employees. It may also provide access to special apps and features depending on user role.

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

The project will mostly be using the **Model-View-Controller** design pattern for the system architecture. System components will exchange data through RESTful APIs to ensure a statelessness among the components. Using this design paradigm, the *view* component may be replaced with a desktop application or a mobile device application using similar business logic with minimal to no changes in the *controller* business logic.

As requests are passed from model to controller, requests will need to be authenticated before being processed. Authentication will be handled through an open authentication framework (e.g., Google, Microsoft, etc.) and the generation and use of JWTs.

#### Route Endpoints

Route endpoints shall be categorized into the following types:

* **API endpoint** - will be used in CRUD (create, retrieve, update, restore) operations; endpoint shall be of the following pattern: <br>```[BASE_URL]/ihrmis/api/vX.XX/[DATANAME]``` where *vX.XX* shall denote the API version
* **Resource endpoint** - will be used to serve images, files, or streams of data; endpoint shall be of the following pattern: <br>```[BASE_URL]/ihrmis/res/[RESOURCE_ID]```
* **User interface endpoint** - the VIEW component; will be used to serve and render web pages using HTML and CSS; may use any other directory under ```[BASE_URL]/ihrmis/```. These routes include the following:
  * ```[BASE_URL]/ihrmis/``` - the base IHRMIS route
  * ```[BASE_URL]/ihrmis/aurora/``` - the Self-Service Portal
  * ```[BASE_URL]/ihrmis/mpasis/``` - the RSP system
  * ```[BASE_URL]/ihrmis/amaira/``` - the RSP system (new name)
  * ```[BASE_URL]/ihrmis/prima/``` - the PM system
  * ```[BASE_URL]/ihrmis/elise/``` - the L&D system
  * ```[BASE_URL]/ihrmis/iris/``` - the R&R system
  * ```[BASE_URL]/ihrmis/mia/``` - the Meeting Information Assistant
  * ```[BASE_URL]/ihrmis/``` - 

To fully implement the principles of RESTful API design, the web API shall use endpoint nouns that directly mirror many of the tables and views in the database.

#### Major Modules

To cater to the different aspects of human resource management (HRM), particularly those accredited under the PRIME-HRM, while ensuring that the resulting information system is easy to maintain, the information system shall be divided into several major modules, each one handling either a specific aspect of HRM or a specific role within the MVC design paradigm.

The following list of proposed modules for the IHRMIS is a running list which may updated anytime a specific feature that can be modularized is realized during development.

* **IHRMIS** - Main API for handling most requests from IHRMIS_UI and SSP_UI
* **PERSEUS** - Personnel Establishment, Roster, Structure, and Employee Utilization Support Module; Plantilla and designations management; mandatory dependency for IHRMIS
* **EmRE** - Employee Records Engine Module; mandatory dependency for IHRMIS
* **ALICE** - Attendance and Leave Information and Coordination Engine Module; mandatory dependency for IHRMIS
* **JANUS** - Joint Authentication and Navigation for Unified Services module; will handle the sign-in, sign-up, and account management requests from the sign-in/sign-up page (JANUS UI)
* **MPaSIS** - Merit Promotion and Selection Information System; PRIME-HRM API for handling requests related to recruitment, selection, and placement; optional dependency for IHRMIS module; might rename to *Assistant for Merit-based Acquisition, Inventory, Recruitment, and Appointment (AMAIRA)*; should have a separate UI
* **PRIMA** - Performance Review and Improvement Management Assistant; PRIME-HRM API for handling requests related to performance management; optional dependency for IHRMIS module; should have a separate UI
* **ELISE** - Employee Learning and Improvement System for Excellence; PRIME-HRM API for handling requests related to professional learning and development; optional dependency for IHRMIS module; should have a separate UI
* **IRIS** - Incentive and Recognition Information System; PRIME-HRM API for handling requests related to rewards and recognition; optional dependency for IHRMIS module; should have a separate UI
* **MIDAS** - Management of Income, Deductions, Allowances, and Compensation Services; Optional payroll management system module; should have a separate UI
* **ARGUS** - Audit, Recording, and Governance for Usage of the System; logging system; dependency for all modules
* **IHRMIS_UI** - Main interface for use by the HRMO and other HR level and Management level personnel
* **AURORA_UI** - Agency Unified Resources, Operations, and Related Applications; Interface for general use

Notwithstanding the major modules, some supporting classes, functions, or constants may also be organized into modules, albeit with lesser relevance to the major features.

## Database Design

Data storage shall be handled by a MySQL database server. As the web API shall be designed according to RESTful principles, the database design shall also adhere to CRUD principles. 

Please refer to this [worksheet](https://depedph.sharepoint.com/:x:/r/sites/SDOSTC-Personnel/_layouts/15/doc2.aspx?sourcedoc=%7BAF834193-02F1-402E-853B-73579CE0F800%7D&file=Data%20Types.xlsx&action=default&mobileredirect=true "Data Types.xlsx") for lists of database tables organized according to categories.

To improve database performance, an optional Redis cache may also be configured.

## Logging Features

There will be two types of IHRMIS logs: database history logs and system logs. Database logs are stored in the database and capture database-related operations, particularly CRUD operations. These may be useful in data security and policy compliance audits. On the other hand, system logs are stored as text files and capture system activities and exceptions encountered during the system's operation. These logs may prove to be useful in the maintenance and troubleshooting of the system.
