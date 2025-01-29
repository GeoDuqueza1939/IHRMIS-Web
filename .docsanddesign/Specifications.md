# SPECIFICATIONS
___
> Target System: Integrated Human Resource Management Information System (IHRMIS)<br>
> Document Version: 0.00
___

## The Purpose of the System

The purpose of the system is to host all other HR-related information systems.

## The Users' Needs

The users shall be performing several tasks, foremost of these are HR-related, using a single, unified web interface:
* Sign in to the system for varied levels of system access
* Encoding and editing of employee information using various information systems
* Management of system accounts
* Viewing of system logs
* Adding of plugins

## What The System Should Be Capable Of

* The system shall provide the main user interface (UI) for all the hosted information systems and allow the user access to their features.
* The system shall feature be an extensible framework which adds information systems and features via plugins.
* Plugins, which may be described as either mandatory or optional, may be classified into the following:
  * Information system plugins
  * Feature plugins
* The following plugin shall be considered mandatory, as these shall either provide the most basic functionalities to the system or serve as pre-requisites of other plugins:
  * Account management plugin
    - shall provide sign-in and account management facilities
  * Employee Records Information System (ERIS) plugin
    - shall provide the primary functions of the information system
  * Management and Assignment of Positions and Plantilla (MAPP) Information System plugin
    - shall provide management facilities for designations, appointments, and mapping of positions and Plantilla items
  * Themes plugin
    - shall provide the user with options in customizing the UI to suit their needs.
