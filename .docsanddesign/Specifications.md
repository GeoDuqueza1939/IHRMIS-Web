# SPECIFICATIONS

___
> Target System: Integrated Human Resource Management Information System (IHRMIS)<br>
> Document Version: 0.00
___

## Description and Purpose of the System

The Integrated Human Resource Management Information System (IHRMIS) is a suite of web-based applications and application programming interfaces (web APIs). IHRMIS will be designed to meet the HR management needs of a Department of Education office. It aims to comply with the requirements of the CSC PRIME-HRM Level III certification (Integrated HRM) while modelling the prescibed subprocesses under the Human Resource Management and Development (HRMD) process as defined in the Department of Education Quality Management System Manual and Procedures and Work Instructions Manual (DepED-QMS-PAWIM). Likewise, it aims to uphold data privacy and security in accordance with the Republic Act No. 10173, otherwise known as the Data Privacy Act of 2012.

## Acronyms and Definition of Terms

The following terms and acronyms are hereby adopted to simplify the identification of specific concepts and entities all throughout this specifications document and avoid wieldy repetition of lengthy names and indentifiers.

* __ASDS__ - Assistant Schools Division Superintendent; commonly serves as the Chairperson of the four (4) PRIME-HRM pillars.
* __CAR__ - Comparative Assessment Result
* __CAR-RQA__ - Comparative Assessment Result - Registry of Qualified Applicants
* __CAReER__ - Comparative Assessment Result for ECP Reclassification
* __CSC__ - Civil Service Commission
* __DBM__ - Department of Budget and Management
* __DBMS__ - Database Management Software
* __DepEd-QMS-PAWIM__ - Department of Education Quality Management System Manual and Procedures and Work Instructions Manual
* __ECP__ - Expanded Career Progression
* __EEOP__ - Equal Employment Opportunity Principle; EOP applicable to RSP procedures
* __EOP__ - Equal Opportunity Principle
* __GSIS__ - Government Service Insurance System
* __HDMF__ - Housing Development Mutual Fund
* __HRDC__ - Human Resource Development Committee
* __HRMD__ - Human Resource Management and Development
* __HRMO__ - Human Resource Management Officer
* __IER__ - Initial Evaluation Result
* __IHRMIS__ - Integrated Human Resource Management Information System
* __ITO__ - Information Technology Officer
* __KRA__ - Key Result Area
* __L&D__ - Learning and Development (PRIME-HRM Pillar)
* __MPaSIS__ - Merit Promotion and Selection Information System; older version of the software
* __MPaSISv2.0__ - Merit Promotion and Selection Information System, version 2.0; the newer version to be developed as a component module or subsystem of IHRMIS
* __ORAOHRA__ - Omnibus Rules on Appointments and Other Human Resource Actions; has 2017 and 2025 versions
* __PhilHealth__ - Philippine Health Insurance, Inc.
* __PLIs__ - Public Lending Institutions
* __PM__ - Performance Management (PRIME-HRM Pillar)
* __PMT__ - Performance Management Team
* __PNPKI__ - Philippine National Public Key Infrastructure
* __PRAISE__ - Program on Awards and Incentives for Service Excellence
* __PRIME-HRM__ - Program to Institutionalize Meritocracy and Excellence in Human Resource Management
* __PSIPOP-GMIS__ - Personal Services Itemization and Plantilla of Personnel - Government Manpower Information System
* __R&R__ - Rewards and Recognition (PRIME-HRM Pillar)
* __RQA__ - Registry of Qualified Applicants
* __RSP__ - Recruitment, Selection, and Placement (PRIME-HRM Pillar)
* __SDS__ - Schools Division Superintendent; the approving authority in the Schools Division Office level
* __SSP__ - Self-Service Portal

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

Other workflows have also been identified to prove also relevant in the development of the IHRMIS. Some may be related to and may or may not be directly categorized under one or more of the above processes. Other still might be incidental to the technical maintenance of the IHRMIS and its modules/subsystems. This list is, in no way, exhaustive and others may still be identified during the course of the system development.

1. Clearances
2. Document Requests
2. Travel Abroad
3. Separation Benefits (GSIS)
4. User and System Role Management
5. System Maintenance
6. Database Maintenance
7. System and Feature Updates (Continuous Development)
8. System Documentation Maintenance

Different office units may share some of the processes in the above lists, and may split KRAs accordingly. In addition, specific roles in the IHRMIS may be assigned to the top management and the ICT office depending on the scope of their responsibilities.

Finally, the IHRMIS will also offer specific features for end-user employees, especially those related to employee records, certifications, and various other employment-related services while upholding their rights to data privacy and security.

### The HRMO and the Personnel Services Unit

The HRMO will be the foremost user of the IHRMIS. As such, the IHRMIS will mostly be tailored around the requirements of the HRMO. Staff of the Personnel Services Unit that the HRMO directly supervises also share the HRMO's roles and responsibilites by virtue of delegation, so they will also be among the primary users of the IHRMIS, along with the HRMO.

As the HRMO, they need to manage or be directly involved in all aspects of human resource management. Ultimately, the HRMO can be considered as the custodian of all personnel records. As such, access to all personnel information and organizational staffing data, particularly those that are synchronized with the Plantilla, is imperative. The HRMO should also be able to assign roles and responsibilities to personnel, particularly those that involve HR management and the PRIME-HRM pillars. For instance, the HRMO may delegate leave management or payroll management to specific Personnel Service Unit staff. Likewise, after designation by the Appointing Authority, membership in the various PRIME-HRM committees shall also be assigned by the HRMO in the IHRMIS so the necessary features can be unlocked for use by those members. In connection with personnel inventory, the HRMO should also be able to modify the organizational structure of the

The HRMO should also be able to upload documents and verify the documents uploaded by others, depending on the process. Likewise, any changes to personnel information shall first be approved before those are committed and fixed in the databases of IHRMIS. For instance, an employee could update their government ID numbers using access to the IHRMIS-SSP. However, the updated information will first need to be approved by the HRMO before it is finalized and fixed. As such, if the information in current personnel records such as the 201 files and other similar records is insufficient, the HRMO may first notify the concerned employee via the IHRMIS-SSP to ask for additional documents needed to verify the information.

The HRMO also needs to generate specific lists, documents, or reports. Some of these may be generated for submission or endorsement to specific authorities, such as the DepEd Regional Office, DBM Regional Office (in the case of Plantilla Allocation Lists and Reclassification Forms), and the Civil Service Commission. Others may need to be generated to aid in the policy- or decision-making of top management. Others still may be issued in response to process needs or to requests made by employees or even third-parties, such as in the case of requests for Certificates of Employment and Service Records or the issuance of Initial Evaluation Result letters for job applicants.

The HRMO should also be able to securely sign documents online using either their password, self-signed certificate, or PNPKI certificate. They should be able to sign multiple documents at a time if possible and whenever necessary.

### The Schools Division Superintendent

The Schools Division Superintendent is the _Head of Agency,_ the primary _Approving Authority_ of all policies and decisions, and the one who usually acts as the _Appointing Authority_ for all RSP and other staffing processes.

As the Head of Agency, they should have access to statistical HRM information to understand the overall HRM status of the organization and make informed top-level decisions based on these information.

As Approving Authority, they should be able to access all reports, lists, rankings, and documents for their approval, along with other relevant information that will enable them to decide whether to allow or veto such documents or actions.

As the Appointing Authority, they should have access to all pertinent information related to qualified job applicants so they can properly decide on appointments based on objective information. Likewise, in the extended absence of an HRMO, they should be able to assign HRMO roles in the IHRMIS for a specific duration to any staff or official they designate as either the acting HRMO or the OIC of the Personnel Services Unit, provided the designation is in accordance with the CSC ORAOHRA.

Finally, they should also be able to securely sign documents online using either their password, self-signed certificate, or PNPKI certificate. They should be able to sign multiple documents at a time if possible and whenever necessary.

### The Assistant Schools Division Superintendent

In addition to their primary role as the alternate of the Schools Division Superintendent, the Assistant Schools Division Superintendent is commonly designated as the __Chairperson__ of all __PRIME-HRM committees.__

As the Chairperson, they will be presiding in all meetings, deliberations, and proceedings relevant to all these committees. They will also act as the final signatory of all reports, minutes, resolutions, and all other relevant documents whose signature serves to approve or finalize these actions before these are approved by or submitted to the Schools Division Superintendent for information or further action.

In consideration of the above executive roles, they will need access to the IHRMIS features relevant to each PRIME-HRM committee, which include, among others:

* approve and/or digitally sign reports, minutes, resolutions, and all other relevant documents using their password, self-signed certificate, or PNPKI certificate, whichever is necessary or applicable
* set and preside over meetings or sessions via the IHRMIS and provide remarks and recommendations to agenda items and/or job applicant or personnel information
* create polls for voting on issues for resolution
* access job applicant or personnel information relevant to deliberations

The Assistant Schools Division Superintendent may also be designated the role of Approving Authority for a specific duration using the credentials of both the HRMO, the SGOD Chief and the CID Chief. This is to ensure the continuous availability of HRM-related services in the absence of a Schools Division Superintendent.

### The PRIME-HRM Focals

The designated PRIME-HRM Focals are officials and staff whose KRA aligns with the PRIME-HRM processes and their counterpart HRMD subprocesses. They are commonly also assigned as either members or secretariat of the related PRIME-HRM committees. They are as follows:

1. __HRMO__ - The RSP Focal
2. __Planning Officer__ - The PM Focal
3. __SEPS-HRDS__ - The L&D Focal
4. __EPS II-HRDS__ - The R&R Focal

In addition, the SGOD Chief Education Supervisor is currently designated as the __PRIME-HRM Primary Focal__ to oversee the SDO's efforts in the pursuit of PRIME-HRM accreditations from the CSC.

For the RSP Focal, please refer to the HRMO's requirements presented in the preceeding sections. As for the other focal persons, kindly refer to the succeeding sections that discuss the requirements for their positions/designations.

### The Member of the PRIME-HRM Committees

The members of the PRIME-HRM Committees are designated to ensure equity, fairness, and transparency in all proceedings relevant to each PRIME-HRM pillar while maintaining compliance to established policies and guidelines of the DepED, CSC, and all other relevant government entities. Some members are designated _de facto,_ based on their management positions, such as the functional division Chiefs and the Administrative Officer V. Others also come as representations from the employee bodies and associations to ensure the implementation of the EOP.

As members of the committees, they will need access to IHRMIS features that will allow them to officially participate in meetings and sessions set using the IHRMIS and express judgments and decisions, either individually or as a body, to implement policies or actions. They should be able to do the following:

* digitally sign reports, minutes, resolutions, and all other relevant documents using their password, self-signed certificate, or PNPKI certificate, whichever is necessary or applicable
* participate in meetings or sessions via the IHRMIS and provide remarks and recommendations to agenda items and/or job applicant or personnel information
* create, in behalf of the Chairperson, or participate on polls for voting on issues for resolution
* access job applicant or personnel information relevant to deliberations

### The Administrative Officer

The Administrative Officer has an active role in HRM. They act as a signatory in service records, clearances, and other documents relevant to HRM. They are also designated as the Agency Executive Officer (AEO) or the Agency Approving Officer (AAO) and are also involved with the approval of employee benefits and loans. They also serve as a _de facto_ member of the PRIME-HRM committees. As such, they need access to service records and other relevant personnel information so requests, benefits, and loans may be acted upon accordingly. In many cases, they should be able to digitally sign documents using their password, self-signed certificate, or PNPKI certificate. In addition, they shall also have access to the relevant IHRMIS features as a member in the PRIME-HRM committees.

### The Budget Officer

In the perspective of HRM, the Budget Officer is mostly concerned with the preparation of allotments for the salary of personnel and the procurement of assets and supplies the necessity for which is incidental to on-the-job needs of personnel. They may work in tandem with the Payroll Officer in the preparation of salary allotment for specific periods. Depending on requirements, they may need direct access to summarized personnel inventory data or may instead choose to receive reports from the Payroll Officer containing the relevant personnel inventory information that they need. In addition, should they be designated as a member in any of the PRIME-HRM committees, they shall also have access to the relevant IHRMIS features.

### The Supply Officer

The Supply Officer manages assets and supplies that are needed for everyday operations. When preparing plans for the procurement of office supplies, they may use the Position Description Forms that will be made available in the IHRMIS as guides to indentify the office supply needs of personnel.

The Supply Officer also signs clearances. As such, they will sign online clearances using their IHRMIS password, self-signed certificates, or PNPKI certificates.

### The Records Officer

Due to the digitalization of many processes under HRM, some document requests and issuances may no longer directly pass through the Records Unit. However, Records Officer may provide specific directions on how some document requests and issuances may be handled digitally while remaining compliant to agency and government policies on document handling and archiving. Likewise, they may also need reports on the number and details of document requests received and processed via the IHRMIS and the actual duration of processing to monitor compliance with ARTA regulations.

### The Cash Officer

The Cash Officer deals with reimbursements for salary, employee benefits, and remittaces of deductions and contribution to PLIs and employee benefits providers from the government, such as Pag-IBIG HDMF, PhilHealth, and GSIS. Once payrolls and/or remittances are prepared and audited/pre-audited by the Accountant, the Cash Officer then uploads reimbursement data into the agency's host bank to credit salaries to the employees and/or remit contributions to the PLIs and benefits providers. Should the low-priority payroll module of IHRMIS be completed within the timeframe, this auditing-routing workflow would be adapted by the IHRMIS in an online/semi-automated process.

### The Accountant

For employee salary, benefits, deductions, and contributions, the Accountant provides the auditing/pre-auditing process. Once the payroll and the accompanying remittances are prepared, the Accountant audits or pre-audits them to ensure that they are accurately calculated and fully compliant with financial reporting standards of the government, particularly of the Commission on Audit. Should the low-priority payroll module of IHRMIS be completed within the timeframe, this auditing-routing workflow would be adapted by the IHRMIS in an online/semi-automated process.

Another role of the Accountant is in the signing of clearances. They should have access to the attachments of the online clearances so they can use these along with these records to determine whether the employee can be cleared of financial obligations from the Accounting Office. They may sign the clearances using their IHRMIS passwords, self-signed certificates, or PNPKI certificates. Should an employee not be cleared from financial obligations or accountabilities, the Accountant may also add a remark to clarify the reason and identify the documents for compliance, if any.

### The Payroll Officer

The Payroll Officer is the primary official under the Personnel Services Unit responsible for the accurate preparation of payroll and remittances. They need to ensure that all records that form the basis of the payroll are accurate and free from any type of error. Likewise, they should be able to generate and print payrolls, payslips, and other similar outputs using these personnel record.

The DepED Payroll System currently being used is a FoxPro-based system currently being maintained by the DepED Central Office. It uses DBF table files, an old proprietary format compatible with FoxPro and DBase III DBMS systems. As updates to the Payroll System are being cascaded from the Central Office to the Schools Division Offices through the Regional Offices in the form of DBF table and PRG scripts, another FoxPro-compatible scripting format, the IHRMIS Payroll module should be able to accept and consume such updates to maintain compliance and compatibility with the Central Office's payroll system.

Another function needed by the Payroll Officer would be the generation of supplementary payrolls, particularly for new hires, for crediting salary adjustments, and for crediting of benefits claims, as most of these are currently not yet provided by the DepED Payroll System.

### The CID Chief Executive Supervisor

The Curriculum Implementation Division Chief is mostly concerned with teachers and their pedagogical work. However, they are _de-facto_ members of the HRMPSB during hiring cycles that involve teaching and related-teaching, and school administrative positions. As such, they will need access to the same features as other members of the HRMPSB whenever they would fulfill their obligations during the hiring cycles for such positions.

### The SGOD Chief Executive Supervisor

The Schools Governance and Operations Division Chief supervises three (3) out of four PRIME-HRM pillar focals. As such, they might need access to statistical HRM information to not just understand the overall HRM status of the organization but to also guide the focals in the management of their Pillars. Likewise, they are _de-facto_ members of the HRMPSB for Division-level assessments. As such, they will need access to the same features as other members of the HRMPSB whenever they would fulfill their obligations in the Division-level hiring cycles. In addition, as the currently designated PRIME-HRM accreditation focal, they should be able to observe most of the IHRMIS features during development and testing to ensure that the features are compliant with policies and aligned with organizational goals relevant to the PRIME-HRM accreditation.

### The Planning Officer

The Planning Officer of the School Governance and Operations Division (SGOD) is the primary resource person for the determination of teacher requirements in each school under the Schools Division. These data may be gathered either from the DepED's Learner Information System (LIS) or from direct feedback from school heads and/or management. In turn, these data will then need to be reflected on the IHRMIS to guide the personnel inventory and RSP processes.

The Planning Officer is also currently assigned as the focal of the PMT. As such, they need access to past performance and professional data of employees. They should also have a way to setup performance management cycles and manually trigger the beginning of each phase via the IHRMIS. All throughout the cycle, they need a way to monitor the status of performance management as a whole and per school or office unit and view the submitted IPCRFs/OPCRFs of individual employees once they are uploaded and become available. Once all performance ratings have been finalized and submitted, they should be able to close the cycle, signalling the automatic endorsement of the performance data to the HRDC and the PRAISE Committee.

### The Senior Education Program Supervisor for Human Resource Development (SEPS-HRD)

The SEPS-HRD is the L&D focal and designated as one of the primary members of the HRDC. They are tasked with managing employee development and welfare. They should have access to relevant pieces of personnel information and should also be able to track and modify the educational and training record of employees. Likewise, they should be able to summarize or view the summaries of individual and group development plans gathered through the PM pillar of PRIME-HRM, determine L&D needs, and design/implement L&D interventions to bridge gaps in the knowledge, skills, and performance of employees. Once these L&D interventions are implemented and set in the IHRMIS, they should be able to identify, either directly or through nominations from various channels, the suitable participants for these interventions. After the trainings and learning intervention, they should be able to update the personnel records of participants to reflect participation in the trainings and scans of certificates may be also be uploaded.

Aside from direct access to personnal information with respect to the tracking of employee development, they should also have a platform to develop and showcase learning interventions and, in some cases, invite participants to them. Approval by the approving authority may also be done digitally, if possible.

### The Education Program Specialist II for Human Resource Development (EPS II-HRD)

The EPS II-HRD has been designated as the PRIME-HRM focal for R&R and a member of the secretariat of the PRAISE Committee. As the member of the secretariat, they fulfill several roles, including, among others, maintenance of accurate and confidential records of the committee activities, decisions, and any supporting documentation and the maintenance of consolidated nomination documents. In connection with their role, they would need access to relevant data from employee performance, educational attainment, and professional development. They should also be able to organize awards via the IHRMIS and set the criteria and parameters of each award, including the assignment of PRAISE Committee members and the TWG who would handle the screening and deliberation of nominees and awardees. They would also need a way to receive and/or record nominations for the different awards set in IHRMIS. Once rewards and incentives have been given out, they should also be able to update the corresponding employee records of awardees. In the case of monetary incentives, such as loyalty awards and step increments, they should also be able to determine the potential recipients of these incentives and verify whether these recipients have been included in payrolls prepared to credit these incentives to the employees' payroll accounts.

### The Librarian

The Librarian is also a signatory to the clearances. They should be able to sign clearances using their IHRMIS password, self-signed certificate, or PNPKI certificate. They also need a way to provide remarks and additional information in case they choose to not sign a digital clearance.

### The Legal Officer

The Legal Officer is a very important official as they serve as consultants during grievances and in situations of legal ambiguity. Once the HRMO receives queries or grievances that need the attention of the Legal Officer or the top management, grievance mechanisms and procedures may be triggered similar to the procedures and features that shall also be available to PRIME-HRM committees during their meetings and deliberations. The Legal Officer shall be considered as a _de facto_ participant of these procedures while the Assistant Schools Division Superintendent may act as Chairperson. Administrative cases may also be treated as grievances, as well. The HRMO may use the IHRMIS to assign other member to the Grievance Committee in the same way that members are added to the PRIME-HRM Committees. The aggrieved parties may also be added in a similar fashion but may have access to different features, in case they use the IHRMIS-SSP.

The Legal Officer is also a signatory to the clearances. They should be able to sign clearances using their IHRMIS password, self-signed certificate, or PNPKI certificate. They also need a way to provide remarks and additional information in case they choose to not sign a digital clearance.

### The Information Technology Officer

The Information Technology Officer shall delegated with the role of user account maintenance in the IHRMIS. They should be able to create, update, link, merge, or delete user accounts and employee records. They should also have direct access to the physical and low-level components of the server and a system administrator level of access to IHRMIS to aid in troubleshooting and, in the worst case, resolution of system faults and/or data breaches. This includes access to the IHRMIS and server logs to assist in troubleshooting and tracing of system/network activity. To aid in the successful diagnosis of system issues even in the absence of the system developer, they will also need online or physical access to a technical manual that describes IHRMIS in detail, particularly the system architecture, database structure, and web API.

### The End Users

All end users will have progressively varied system access levels in the IHRMIS-SSP. External end users who have no DepED account but can sign up or sign in using a valid email account should only have access to the Job Application page where they could view job postings, submit job applications, edit their user profile, track the status of their job applications, and submit queries. Regular end users should have additional interfaces where they could view and edit, among others, their personal and employee data, educational attainment, work experience, service record, trainings, performance data, and awards/incentives received. They should also be able to nominate other personnel for awards, vote on polls, or request documents. Designated committee members should also be able to join virtual meetings, sessions, or deliberations, vote on polls, add remarks to agenda items, and sign online documents using their IHRMIS password, self-signed certificate, or PNPKI certificate. For other higher-level features, they will need to access the main IHRMIS interface.

## What The System Should Be Capable Of

The IHRMIS will be a suite of web-based applications. The main or core system shall provide most of the functionalities needed by the HRMO and the ITO to manage the system. Along with its modules or subsystems, it should afford the following features and actions:

* Manage employee records and user accounts
* Manage Plantilla, staffing patterns, and organizational structure
* Analyze of teacher/personnel requirements for each office or school
* Create hiring cycles and HRMPSB teams to manage them
* Manage the hiring cycles, guide the evaluation process, and records assessment scores
* Create performance management cycles and track their status
* Provide an interface that will aid in the analysis of the learning needs of personnel, the summarization of development plans, the formulation of L&D interventions, and the selection and/or assignment of participants to the L&D interventions
* Update the training data of personnel
* Create award cycles and assign PRAISE members and TWG who will manage them
* Record nominee and awardee information
* Create ad hoc teams for hearing grievances and/or administrative cases
* Create and manage virtual meetings of committees while allowing participants to add remarks, vote on polls, or sign meeting documents online using their IHRMIS password, self-signed certificate, and PNPKI certificate
* Submit comments, suggestions, queries, complaints, and grievances
* Generate service records, clearances, indorsements, and other documents and reports
* Manage an online 201 file repository
* Allow the general signing and/or approval of online documents using users' IHRMIS password, self-signed certificate, and PNPKI certificate
* View of attachments to documents for signing or approval
* Automatic or manual routing of online documents to the next concerned offices or officials
* Manage shift assignments, attendance, leaves, discipline, and employee welfare
* Manage the policies library
* Approve updates to user/applicant/employee profiles

The IHRMIS-SSP, the end user-oriented subsystem of the IHRMIS, should allow the following actions:

* Create user accounts using valid emails
* Sign in using DepED accounts
* Create and update user/applicant/employee profile
* Upload attachments to user profile for verification
* View job postings and announcements for external users
* Apply to job postings
* View and track the status of job applications
* View CARs and CAR-RQAs
* Submit comments, suggestions, queries, complaints, and grievances
* Browse the policies library
* Request for documents
* Submit requests for HR actions (e.g., leave, transfer, resignation, etc.) and attach relevant documents
* View announcements for employees
* Vote on polls
* Submit nominations to awards
* Manage performance cycles and data
* Request participation in open trainings
* Join virtual committee meetings and deliberations
* Allow the general signing and/or approval of online documents using users' IHRMIS password, self-signed certificate, and PNPKI certificate
