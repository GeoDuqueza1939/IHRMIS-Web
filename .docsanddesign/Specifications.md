# SPECIFICATIONS

___
> Target System: Integrated Human Resource Management Information System (IHRMIS)<br>
> Document Version: 0.00
___

## Description and Purpose of the System

The Integrated Human Resource Management Information System (IHRMIS) is a suite of web-based applications and application programming interfaces (web APIs). IHRMIS will be designed to meet the HR management needs of a Department of Education office. It aims to comply with the requirements of the CSC PRIME-HRM Level III certification (Integrated HRM) while modelling the prescibed subprocesses under the Human Resource Management and Development (HRMD) process as defined in the Department of Education Quality Management System Manual and Procedures and Work Instructions Manual (DepED-QMS-PAWIM). Likewise, it aims to uphold data privacy and security in accordance with the Republic Act No. 10173, otherwise known as the Data Privacy Act of 2012.

## Acronyms and Definition of Terms

The following terms and acronyms are hereby adopted to simplify the identification of specific concepts and entities all throughout this specifications document and avoid wieldy repetition of lengthy names and indentifiers.
<!-- 
* __IHRMIS__ - Integrated Human Resource Management Information System
* __CSC__ - Civil Service Commission
* __DBM__ - Department of Budget and Management
* __PRIME-HRM__ - Program to Institutionalize Meritocracy and Excellence in Human Resource Management
* __NOSCA__ - Notice of Organization, Staffing, and Compensation Action
* __KRA__ - Key Result Area
* __HRMD__ - Human Resource Management and Development
* __DepEd-QMS-PAWIM__ - Department of Education Quality Management System Manual and Procedures and Work Instructions Manual
* __ORAOHRA__ - Omnibus Rules on Appointments and Other Human Resource Actions; has 2017 and 2025 versions
* __RSP__ - Recruitment, Selection, and Placement (PRIME-HRM Pillar)
* __PM__ - Performance Management (PRIME-HRM Pillar)
* __L&D__ - Learning and Development (PRIME-HRM Pillar)
* __R&R__ - Rewards and Recognition (PRIME-HRM Pillar)
* __HRMO__ - Human Resource Management Officer
* __ITO__ - Information Technology Officer
* __SDS__ - Schools Division Superintendent; the approving authority in the Schools Division Office level
* __ASDS__ - Assistant Schools Division Superintendent; commonly serves as the Chairperson of the four (4) PRIME-HRM pillars.
* __PSIPOP-GMIS__ - Personal Services Itemization and Plantilla of Personnel - Government Manpower Information System
* __MPaSIS__ - Merit Promotion and Selection Information System; older version of the software
* __MPaSISv2.0__ - Merit Promotion and Selection Information System, version 2.0; the newer version to be developed as a component module or subsystem of IHRMIS
* __RQA__ - Registry of Qualified Applicants
* __CAR__ - Comparative Assessment Result
* __CAR-RQA__ - Comparative Assessment Result - Registry of Qualified Applicants
* __CAReER__ - Comparative Assessment Result for ECP Reclassification
* __IER__ - Initial Evaluation Result
* __ECP__ - Expanded Career Progression
* __SSP__ - Self-Service Portal
* __PNPKI__ - Philippine National Public Key Infrastructure
-->

## The Users' Needs

The IHRMIS will have different kinds of users that fulfill various roles. It will be designed in consideration of each of their unique needs. These needs are summarized according to the following HRMD processes as defined under the DepED-QMS-PAWIM.

1. Compensation and Benefits
2. Employee Relations
3. Employee's Welfare
4. Leave Management
5. Personnel Inventory
6. Personnel Performance Management
7. Personnel Records Management
8. Professional Development/Learning and Development
9. Recruitment, Selection, Placement, and Induction
10. Rewards and Recognition

Likewise, the following processes, which correspond to PRIME-HRM pillars, are managed by the appropriate HRM committees:

1. Recruitment, Selection, and Placement - managed by the __HRMPSB__
2. Performance Management - managed by the __PMT__
3. Learning and Development - managed by the __HRDC__
4. Rewards and Recognition - managed by the __PRAISE Committee__

Different office units may share some of the above processes, and may split KRAs accordingly. In addition, specific roles in the IHRMIS may be assigned to the top management and the ICT office depending on the scope of their responsibilities.

Finally, the IHRMIS will also offer specific features for end-user employees, especially those related to employee records and various other employment-related services while upholding their rights to data privacy and security.

### The HRMO and the Personnel Services Unit

The HRMO will be the foremost user of the IHRMIS. As such, the IHRMIS will mostly need to be tailored around the requirements of the HRMO. Staff of the Personnel Services Unit that the HRMO directly supervises also share the HRMO's roles and responsibilites by virtue of delegation, so they will also be among the primary users of the IHRMIS, along with the HRMO.

As the HRMO, they need to manage or be directly involved in all aspects of human resource management. Access to all personnel information and organizational staffing data, particularly those that are synchronized with the Plantilla, is imperative. The HRMO should also be able to assign roles and responsibilities to personnel, particularly those that involve HR management and the PRIME-HRM pillars. For instance, the HRMO may delegate leave management or payroll management to specific Personnel Service Unit staff. Likewise, after designation by the Appointing Authority, membership in the various PRIME-HRM committees also need to be assigned by the HRMO in the IHRMIS so the necessary features can be unlocked for use by those members. In connection with personnel inventory, the HRMO will need to be able to modify the organizational structure of the

The HRMO should also be able to upload documents and verify the documents uploaded by others, depending on the process. Likewise, any changes to personnel information shall first be approved before those are committed and fixed in the databases of IHRMIS. For instance, an employee could update their government ID numbers using access to the IHRMIS-SSP. However, the updated information will first need to be approved by the HRMO before it is finalized and fixed. As such, if the information in current personnel records such as the 201 files and other similar records is insufficient, the HRMO may first notify the concerned employee via the IHRMIS-SSP to ask for additional documents needed to verify the information.

The HRMO also needs to generate specific lists, documents, or reports. Some of these may be generated for submission to specific authorities, such as the DepEd Regional Office, DBM Regional Office (in the case of Plantilla Allocation Lists and Reclassification Forms), and the Civil Service Commission. Others may need to be generated to aid in the policy- or decision-making of top management. Others still may be issued in response to process needs or to requests made by employees or even third-parties, such as in the case of requests for Certificates of Employment and Service Records or the issuance of Initial Evaluation Result letters for job applicants.

The HRMO should also be able to securely sign documents online using either their password, self-signed certificate, or PNPKI certificate. They should be able to sign multiple documents at a time if possible and whenever necessary.

### The Schools Division Superintendent

The Schools Division Superintendent is the _Head of Agency,_ the primary _Approving Authority_ of all policies and decisions, and the one who usually acts as the _Appointing Authority_ for all RSP and other staffing processes.

As the Head of Agency, they should have access to statistical HRM information to understand the overall HRM status of the organization and make informed top-level decisions based on these information.

As Approving Authority, they should be able to access all reports, lists, rankings, and documents for their approval, along with other relevant information that will enable them to decide whether to allow or veto such documents or actions.

As the Appointing Authority, they should have access to all pertinent information related to qualified job applicants so they can properly decide on appointments based on objective information.

Finally, they should also be able to securely sign documents online using either their password, self-signed certificate, or PNPKI certificate. They should be able to sign multiple documents at a time if possible and whenever necessary.

### Planning Officer

The Planning Officer of the School Governance and Operations Division (SGOD) is the primary resource person for the determination of teacher requirements in each school under the Schools Division. These data may be gathered either from the DepED's Learner Information System (LIS) or from direct feedback from school heads and/or management. In turn, these data will then be reflected on the IHRMIS to guide the personnel inventory and RSP processes.


>>> old requirements
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
