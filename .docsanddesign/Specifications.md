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

Different office units may share some of the above processes, and they may split KRAs accordingly. In addition, specific roles in the IHRMIS may be assigned to the top management and the ICT office depending on the scope of their responsibilities.

Finally, the IHRMIS will also offer specific features for end-user employees, especially those related to employee records and various other employment-related services while upholding their rights to data privacy and security.

### The HRMO and the Personnel Services Unit

The HRMO will be the foremost user of the IHRMIS. As such, the IHRMIS will mostly need to be tailored around the requirements of the HRMO and as well as of the Personnel Services Unit. Their roles and the services they cater to can be summarized in the processes/KRAs described in the succeeding subsections.

#### 1. Personnel Inventory

The management of the personnel inventory is a very significant role, as the personnel inventory reflects the human resource structure of the organization. The personnel inventory helps define the organizational units that compose the organization and the roles, skills, and expertise (i.e., positions) needed to fulfill the purpose of said units. As such, it allows the organization to effectively allocate the necessary manpower to the appropriate units and further identify vacancies, excess personnel, and other staffing patterns and needs. The IHRMIS features for this area may be used in conjuction with the PSIPOP-GMIS of the DBM, which serves as the primary data source for manpower information and as basis for determining the Personal Services (PS) budgetary requirement of DepED (DO 63, s. 2026). Likewise, non-plantilla positions such as those engaged under job orders and contract of service, DepED-funded or otherwise, may also be managed in a similar fashion. Issued NOSCAs will either add or remove Plantilla item positions from the inventory. HR actions that move personnel horizontally across the organization, such as designations, detail, reassignments, etc., will also be managed as well. HR actions that either place employees into or remove employees from Plantilla items, such as appointment, promotion, transfer, separation, resignation, retirement, dropping from the roll, etc., shall also be reflected in IHRMIS, where a position could be marked as either filled, unfilled, or phased out.

The organization of data for the personnel inventory user interface will be as follows:

* The organization shall be divided into organizational units.
* Clicking on an organizational unit will open a page containing its details, such as name, organization ID, parent organization unit, positions allocated, organizational subunits, and other information. The branches of an organizational unit may be traversed just like pages of any other website, accessible through a breadcrumbs feature.
* Clicking on a position title will open the position details page.
* Clicking on an employee name or number will open an employee record page that contains only the basic information about the employee and a button or link for accessing all the employee's information.

For the purpose of continuity with current personnel inventory systems and workflow, existing job description and term of reference documents will serve as the model for "cookie-cutter" position templates or schemas that will define the KRA of Plantilla item and non-Plantilla positions. This will eventually bridge the gap between Personnel Inventory and the PM of PRIME-HRM.

#### 1. Recruitment, Selection, Placement, and Induction (shared with SGOD-HRDS)

The RSP of PRIME-HRM covers the recruitment, selection, placement, induction, and onboarding of new hires and promoted employees. It is, more or less, the equivalent of DepED-QMS-PAWIM's Recruitment, Selection, Placement, and Induction subprocess of the HRMD. Some parts of the process is sometimes managed using the older MPaSIS, albeit retaining some of the inherent gaps in the current HR management processes. It generally follows the following phases:

1. __Publication and/or Posting of Vacancies or Call for Applications.__ This phase is concerned with two steps: the _publication_ of new or vacant Plantilla items and the _posting_ of either a job vacancy or a call for applications. The manner in which the steps are undertaken varies depending on position category. <br><br>For non-teaching Plantilla item positions, the item is published online in the CSC Career Portal while a notice of vacancy is simultaneously posted via an official memorandum, implying the prior existence of a vacant position marked in the personnel inventory. For teaching positions, a call for applications is posted instead, even without the publication of a teaching item. This is most suitably done before the beginning of the next school year to prepare an RQA, which serves as a pool of possible appointees, for upcoming vacancies in teaching positions. <br><br>Regardless of the variation, in MPaSISv2.0, an RSP hiring cycle shall be initiated on the involved positions, for which a specific schedule is defined to manage and assess the execution of phases and tasks and a team of staff and/or officials is set as HRMPSB members and/or alternates. Vacant positions of the same position title and job description or KRAs may be grouped in one (1) hiring cycle, if necessary. For example, openings for three (3) AO II items to be assigned in the Elementary schools may be combined into a single hiring cycle, so that, in effect, applicants will be applying for any of the three positions regardless of station. Another use case would be in processing applications for reclassification under the ECP System, in which positions for application have no particular station of assignment or subject major requirement.

2. __Submission of Applications.__ In this phase, applicants submit their applications to the posted positions. This period usually follows the 10-day publication and posting period. However, the duration may be modified depending on circumstance, i.e., extension of submission period _(should be backed by official issuance)_, submission of Teacher I applications (may take one (1) month or more), etc. <br><br>Paper-based applications are first checked for completion in order to avoid disqualification due to incomplete documents. To guide the HRMO and other assigned personnel in checking, the applicant's name and position applied will be encoded in MPaSISv2.0 and checkboxes are ticked on the online form depending on the available documents. Upon submission of the online checklist, an application code will be generated and shall be written on the actual paper-based checklist. Checkboxes on the actual paper-based checklist will also be ticked to match those in MPaSISv2.0. The applicant then authenticates the checklist through public notary or any public official authorized to officiate oaths before it is finally submitted. <br><br>For online applications via the SSP, applicants will sign up for an account using a valid email address or phone number _(subject to budgetting)_ and encode their own personal details and credentials. They will also upload a scanned PDF or image of the corresponding document for each of their credentials. The online application process will not continue unless the corresponding document of the credential is uploaded. <br><br>After encoding and uploading, an online version of the omnibus oaths will be presented to the applicant and, upon scrolling the oaths and ticking the checkboxes, the applicant may submit the online application. Upon successful submission, the generated application code will be displayed on screen and will also be sent to the applicant's registered email address and phone number _(subject to budgetting)_. In case the applicant applies via email, the applicant shall be sent a reply with a link and a set of intructions regarding the online application using the SSP.

3. __Initial Evaluation.__ Once the application has been fully submitted after ensuring completeness, it will then undergo initial evaluation vis-a-vis the CSC-approved Qualification Standards for the position applied. For online applications, it will be an onscreen checking of personal details and the verification of all encoded credentials against the uploaded scanned credentials. For paper-based applications, assigned personnel will encode the applicant's data into MPaSISv2.0 similar to the older MPaSIS workflow. <br><br>Once all applications for a position have undergone initial evaluation, an IER shall be generated for review by the HRMO using the HRMO account. When the IER has been verified, it is finalized and approved using the HRMO's password, self-signed certificate, or PNPKI certificate. The IER may then be downloaded as a signed PDF, printed for filing or posting, or accessed directly via a link to the SSP. The finalization will trigger a server-based script that will generate a queue of signed PDF's of individual initial evaluation results that will be sent to all applicants via email. <br><br>To maintain the integrity of the finalized IER, no further edits or additional applications shall be allowed or added on the IER unless a majority of the HRMPSB team assigned to the hiring cycle (members or alternates, if corresponding member is unavailable) along with the concurrence of the HRMPSB Chairperson, approves the unfinalization of the said IER using their IHRMIS password, self-signed certificate, or PNPKI certificate.

4. __Comparative Assessment.__ Once the IER has been finalized, a button or link shall be available to the HRMO to allow editing an invitation email containing details regarding the Comparative Assessments, such as the schedule, venue, and other reminders related to the assessments. After editing and submitting the email, it will trigger a server-based script that will generate a queue of emails that will be sent to all _qualified_ applicants. The IHRMIS may then be used to create different sets of groupings of applicants for each round of assessments. These groupings shall be used to check the attendance of applicants on the day of the Comparative Assessment for each assessment and for the immediate recording of marks, if necessary. The HRMO account will be used to assign monitors and/or evaluators to these groups. Due to the lack of manpower, non-permanent employees may also be assigned as monitors for these groups as long as they have an IHRMIS account. <br><br>During and after the assessments, a link in the SSP may be used to access the in-progress and unfinalized CAR. This CAR may also be shown to the applicants inside the assessment grounds using a large screen so applicants may have an idea of their current standing among the rankings. After all scores are encoded into the MPaSISv2.0, the CAR may then be marked by the HRMO as _for deliberation,_ to signify its endorsement to the HRMPSB for discussions and deliberation. While it is marked for deliberation, the CAR becomes inaccessible except to the members of the HRMPSB assigned for the hiring cycle.

5. __Deliberation and Recommendation of the CAR.__ Once the CAR is marked for deliberation, each member or alternate logs into MPaSISv2.0 to enter the virtual deliberation room using their IHRMIS password. During the deliberation process, an HRMPSB member has precedence over the corresponding alternate. Once a member has entered, the corresponding alternate can no longer enter unless the said member leaves the virtual deliberation or logs out of MPaSISv2.0. Conversely, when a member enters while the alternate is already present, the alternate is forced out. After all available members and/or alternates have entered, the HRMPSB Chairperson may declare a quorum by clicking on the appropriate button and enters their password. <br><br>All throughout the deliberation, members may add their own comments (not visible in the CAR) and remarks (visible under the Remarks column) to the CAR and the assigned secretariat also encodes the minutes of the deliberation in a similar manner. Applicant's scoresheets may also be modified when necessary by approval of a majority in the quorum using the members passwords. Once the deliberation comes to a close, the members may finalize the CAR and affix their virtual signature using their IHRMIS passwords, self-signed certificates, or PNPKI certificates. The HRMPSB Chairperson then approves the online CAR for recommendation to the Appointing Authority by using their IHRMIS password, self-signed certificate, or PNPKI certificate, marking it as _for recommendation._ In turn, the Appointing Authority approves the CAR for release using their IHRMIS password, self-signed certificate, or PNPKI certificate, marking it as _approved_. A link or button in both the SSP and the MPaSISv2.0 now gives access to the online CAR, which may be downloaded as a PDF file or printed to paper for posting.

6. __Appointment and Onboarding.__ The Appointing Authority selects the viable applicants for appointment and marks it as _for appointment_ or may request a background check for each one by marking them as _for background investigation._ If the applicant is for background check, the MPaSISv2.0 notifies the HRMO of this request. The HRMO may use the MPaSISv2.0 to add notes regarding the background check, mark the applicant as either _pass_ or _fail_, or assign the background check to another personnel altogether. If failed, the process is repeated, otherwise, the Appointing Authority marks the applicant as _for appointment._ An applicant marked as _for appointment_ receives an email with instructions to report to the HRMO for appointment details and instructions. <br><br>After communicating the result directly to the applicant, the HRMO then sets an appointment date and may then continue to generate drafts of the standard appointment papers such as the Oath of Office, the Certification of Assumption to Duty, and the actual appointment form. If the applicant is able to comply with the appointment requirements on or before the set appointment date, the HRMO triggers the applicant's appointment in MPaSISv2.0, during which an employee record is created from the applicant record and integrated into IHRMIS. <br><br>Simultaneously, while the applicant is marked as _for appointment,_ the L&D focal/SEPS-HRD receives a notification in the IHRMIS so that an Onboarding and Induction plan is prepared for the applicant appointee.

#### 1. Personnel Records Management
#### 1. Compensation and Benefits (shared with the Financial Services Unit)
#### 1. Employee's Welfare (SGOD-HRDS)
#### 1. Leave Management
#### 1. Employee Relations
#### 1. Personnel Performance Management (shared with SGOD-HRDS)
#### 1. Professional Development/Learning and Development (shared with SGOD-HRDS)
#### 1. Rewards and Recognition (SGOD-HRDS)



### Planning Officer

#### 1. Personnel Inventory

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
