-- Schema generated from .docsanddesign/DB-ERD.mwb
-- by tools/mwb-ddl.mjs on 2026-10-12T01:34:00.645Z
-- DO NOT hand-edit: the .mwb model is the source of truth; regenerate.

CREATE DATABASE IF NOT EXISTS `ihrmis` CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `ihrmis`;
SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `Classroom_Observation` (
  `classroom_observationId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empno` VARCHAR(50) NOT NULL,
  `observer_empno` VARCHAR(50) NULL,
  `conducted_on` DATE NULL,
  `concurred_on` DATE NULL,
  `observer_remarks` LONGTEXT NULL,
  PRIMARY KEY (`classroom_observationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `ENUM_Civil_Status` (
  `civil_status` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`civil_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Not specified
1: Single
2: Married
3: Divorced
4: Widow/Widower';

CREATE TABLE `ENUM_Coaching_Mechanism` (
  `coaching_mechanism` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`coaching_mechanism`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values:
0: Others
1: Meeting (One-on-One)
2: Meeting (Group)
3: Learning Action Cell Session
4: Walk-through Observation
5: Workshop

"Others" should always be displayed at the end of the list.';

CREATE TABLE `ENUM_Competency_Type` (
  `competency_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`competency_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: Unknown
1: Core
2: Leadership
...';

CREATE TABLE `ENUM_Criterion_Type` (
  `criterion_type` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`criterion_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Raw
1: Weighted
2: Cumulative
3: Selection
4: Incremental';

CREATE TABLE `ENUM_Disability_Type` (
  `disability_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`disability_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: No declared disability
1: Disabled (not specified)
2: Psychosocial Disability
3: Chronic Illness
4: Learning Disability
5: Visual Disability
6: Orthopedic/Physical Disability
7: Mental Disability
8: Hearing Disability
9: Speech and Language Impairment';

CREATE TABLE `ENUM_Educ_Level` (
  `educ_level` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`educ_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested based on DepEd Order 7, s 2023:
0: None Required
1: Can Read and Write
2: Elementary Graduate
3: Completed Junior High School (K to 12)
4: Senior High School Graduate (K to 12)/High School Graduate (Old Curriculum)
5: Completed 2 years in College
6: Bachelor''s Degree
7: Master''s Degree
8: Doctorate';

CREATE TABLE `ENUM_Eligibility_Type` (
  `eligibility_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  `abbrev` VARCHAR(50) NOT NULL,
  `dbm_abbrev` VARCHAR(10) NOT NULL COMMENT 'For use in DBM PSIPOP (RA 1080 has no field)',
  PRIMARY KEY (`eligibility_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: None
...
100: Career Sub-Professional Eligibility
...
500: Career Professional Eligibility
501: Honor Graduate Eligibility
...
600: RA 1080
...
1000: Career Executive Service Eligibility';

CREATE TABLE `ENUM_Emp_Status` (
  `employment_status` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`employment_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: Unknown
1: Permanent
2: Provisional
3: Temporary
4: Substitute
5: Coterminous
6: Fixed Term
7: Contractual
8: Casual
9: Elective
10: Presidential Appointment
11: Designation
12: Contract of Service (COS)
13: Job Order (JO)
14: Local School Board - Job Order (LSB)
15: Government Internship Program (GIP)
16: Internship/On-the-Job Training (OJT)
17: Immersion (SHS)';

CREATE TABLE `ENUM_Engagement_Term` (
  `engagement_term` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`engagement_term`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: Unknown
1: Appointment
2: Contract
3: Contract of Service
4: Job Order
5: Government Internship Program (GIP)
6: College Internship/On-the-Job Training (OJT)
7: Workplace/Industry Immersion (SHS)';

CREATE TABLE `ENUM_Fund_Source` (
  `position_classification` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`position_classification`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: None
1: MOOE
2; Sub-ARO
3: Special Education Fund (SEF)
4: Government Internship Program (GIP)';

CREATE TABLE `ENUM_HR_Action` (
  `hr_action` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  `appointment` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `notice` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `office_order` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `moa` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `service_record` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Include the HR action in an employee''s service record',
  `separation` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Mode of separation',
  `request` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Can be requested by employees',
  PRIMARY KEY (`hr_action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Unknown
# Nature of Appointment:
1: Original Appointment
2: Promotion
3: Transfer
4: Reemployment
5: Reappointment
6: Reinstatement to Comparable Position/Item
7: Demotion (Reorganization/Voluntary)
8: Reclassification
# Adjustments or Movements of Human Resource Without Need of Issuance of an Appointment
9 - Change in Item Number
10 - Salary Adjustment
11 - Step Increment
12 - Reinstatement to the Same Position/Item
13 - Demotion (Disciplinary Action)
14 - CTI
# Other Human Resource Actions
15 - Reassignment
16 - Detail
17 - Designation
# other legal bases
18 - Secondment
# Modes of separation
19: Resignation
20: Dismissal
21: Dropped from the Roll
22: Termination
23: Expiration of Appointment
24: Retirement
25: Death
26: Invalidated Appointment
27: Revocation of Office Order/Special Order';

CREATE TABLE `ENUM_ID_Type` (
  `id_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`id_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Unknown
1: Internal
2: PhilSys Number (PSN)
3: UMID ID No.
4: BP Number (GSIS)
5: SS Number (SSS)
6: TIN (BIR)
7: PIN (PhilHealth)
8: Pag-IBIG No.
9: Voter''s ID
10: Postal ID
11: NBI Clearance';

CREATE TABLE `ENUM_Item_Status` (
  `item_status` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`item_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Active
1: For Publication
2: Published
3: For Reclassification
4: Dissolved';

CREATE TABLE `ENUM_Location_Type` (
  `location_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`location_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `ENUM_OAuth_Provider` (
  `provider` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`provider`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Not specified
1: Local
2: Google
3: Microsoft 365';

CREATE TABLE `ENUM_Org_Level` (
  `org_level` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`org_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='May depend on agency/organizational hierarchy; for DepEd, refer to the following:
0: Unknown
1: National Government
2: Department of Education
3: Bureau
4: Regional Office
5: Division Office
6: District/Cluster Office
7: School
...';

CREATE TABLE `ENUM_Org_Type` (
  `org_type` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`org_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: External
1: Head Office
2: Functional Division
3: Office Unit
4: School
5: School Department

Suggested values for LGU:
0: Not specified
1: Province
2: City
3: Municipality';

CREATE TABLE `ENUM_PM_Action` (
  `pm_action` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`pm_action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values:
0: Not specified
1: Drafted
2: Agreed
3: Received Coaching
4: Provided Coaching
5: Redrafted/Edited
6: Replaced
7: Self-Reviewed
8: Reviewed
9: Approved';

CREATE TABLE `ENUM_PM_Indicator_Type` (
  `pm_indicator_type` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`pm_indicator_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Unspecified
1: Quality
2: Efficiency
3: Timeliness';

CREATE TABLE `ENUM_PM_Role` (
  `pm_role` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`pm_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: Ratee
1: PMT Chairperson
2: PMT Member
3: PMT Secretariat
4: PMT Observer
5: Technical Support
6: General Support
7: Rater
8: Approver';

CREATE TABLE `ENUM_PPST_Domain` (
  `ppst_domain` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`ppst_domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `ENUM_Phone_Type` (
  `phone_type` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`phone_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Mobile
1: Landline
2: Fax
3: Other';

CREATE TABLE `ENUM_Position_Category` (
  `position_category` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`position_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: Unknown
1: Teaching
2: School Administration
3: Related-Teaching
4: Non-Teaching (Non-General Services)
5: Non-Teaching (General Services)';

CREATE TABLE `ENUM_QS_Type` (
  `qs_type` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`qs_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: Not specified
1: Education
2: Training
3: Work Experience
4: Eligibility
5: Competency';

CREATE TABLE `ENUM_RSP_Level` (
  `rsp_level` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`rsp_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd:
0: Not specified
1: National
2: Regional
3: Division
4: District/Cluster
5: School';

CREATE TABLE `ENUM_RSP_Phase` (
  `rsp_phase` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`rsp_phase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values  for DepEd
0: Unknown
1: Publication/Posting of Vacancies/Call for Applications
2: Submission of Applications
3: Initial Evaluation
4: Comparative Assessment
5: Deliberation and Recommendation of the CAR
6: Appointment and Onboarding';

CREATE TABLE `ENUM_Sex` (
  `sex` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`sex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Sex assigned at birth or through jurisprudence 
0: Not specified
1: Male
2: Female';

CREATE TABLE `ENUM_Teacher_Career_Stage` (
  `career_stage` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`career_stage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='DepEd only
0: Not specified
1: Beginning
2: Proficient
3: Highly Proficient
4: Distinguished';

CREATE TABLE `ENUM_Team_Role` (
  `team_role` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`team_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd
0: Not specified
1: Chairperson
2: Member
3: Secretariat
4: Evaluator
5: Encoder
6: Technical Support
7: General Support
8: Focal Person';

CREATE TABLE `ENUM_Time_Unit` (
  `time_unit` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`time_unit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Unknown
1: minute
2: hour
3: day
4: week
5: month
6: trimester
7: semester
8: school year
9: year';

CREATE TABLE `ENUM_Training_Type` (
  `training_type` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`training_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Not specified
1: Managerial
2: Supervisory
3: Technical
4: Curriculum
5: Pedagogy
6: Learning Area
7: Educational Supervision
...';

CREATE TABLE `ENUM_User_Status` (
  `status` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Not specified
1: Active
2: Inactive
3: Separated';

CREATE TABLE `ENUM_User_Type` (
  `user_type` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`user_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='0: Not specified
1: External
2: Employee';

CREATE TABLE `ENUM_Year_Level_Completed` (
  `level_completed` VARCHAR(10) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`level_completed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='For Bachelor''s Degree only:
1st year
2nd year
3rd year
4th year
5th year';

CREATE TABLE `Employee` (
  `empno` VARCHAR(50) NOT NULL COMMENT 'Employees with appointments shall be assigned with employee numbers provided by the HRIS of the DepEd Central Office or, in cases of new hires, the plantilla item number of the position they filled. Personnel and service providers without appointments, engaged via contract of service or job order, deployed by the Local or Provincial School Board, or governed via internship or immersion MOAs may be assigned an employee number based on their engagement agreement and the date they started.',
  `personId` BIGINT UNSIGNED NOT NULL,
  `start_date` DATE NOT NULL COMMENT 'Oficial start of engagement; corresponds to original appointment date for employees with appointment',
  `assumption_date` DATE NULL COMMENT 'Date of assumption to duty; actual start date',
  `last_promotion_date` DATE NULL COMMENT 'For appointed employees only',
  `last_step_increment_date` DATE NULL COMMENT 'For appointed employees only',
  `tax_code` VARCHAR(10) NULL,
  PRIMARY KEY (`empno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `MFO` (
  `mfoId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `mfo` VARCHAR(255) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`mfoId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Major Final Outputs for DepEd
0: Unknown
1: Basic Education Services
2: Regulatory and Developmental Services
3: Administrative and Support Services';

CREATE TABLE `Nominee_Evaluation` (
  `nominee_evaluationId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nomineeId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`nominee_evaluationId`),
  KEY `fk_Nominee_Evaluation_Nominee1_idx` (`nomineeId`),
  CONSTRAINT `fk_Nominee_Evaluation_Nominee1` FOREIGN KEY (`nomineeId`) REFERENCES `?` (`nomineeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Nominee_Evaluation_History` (
  `nom_eval_histId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nominee_evaluationId` INT UNSIGNED NOT NULL,
  `memberId` BIGINT UNSIGNED NOT NULL COMMENT 'R&R member who viewed or modified the record',
  `update` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'FALSE: Viewed evaluation record
TRUE: Edited/saved evaluation record',
  `timestamp` TIMESTAMP_F NOT NULL,
  PRIMARY KEY (`nom_eval_histId`),
  KEY `fk_Nominee_Evaluation_History_Nominee_Evaluation1_idx` (`nominee_evaluationId`),
  KEY `fk_Nominee_Evaluation_History_Team_Member1_idx` (`memberId`),
  CONSTRAINT `fk_Nominee_Evaluation_History_Nominee_Evaluation1` FOREIGN KEY (`nominee_evaluationId`) REFERENCES `?` (`nominee_evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nominee_Evaluation_History_Team_Member1` FOREIGN KEY (`memberId`) REFERENCES `?` (`memberId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Right` (
  `rightId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(80) NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`rightId`),
  UNIQUE KEY `uq_Right_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Seed rights (minimum): rights.assign, roles.assign, users.manage, users.link.approve';

CREATE TABLE `Role` (
  `roleId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(50) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`roleId`),
  UNIQUE KEY `uq_Role_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Seed: JOB_APPLICANT (default for new users), EXTERNAL_USER, REGULAR_EMPLOYEE, HRMO, SYSTEM_ADMIN';

CREATE TABLE `Team` (
  `teamId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `team_name` VARCHAR(100) NULL,
  `constituted_by` VARCHAR(50) NULL COMMENT 'Employee number',
  `constituted_on` DATETIME NULL,
  `decommissioned_by` VARCHAR(50) NULL,
  `decommissioned_on` DATETIME NULL,
  PRIMARY KEY (`teamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Criterion` (
  `criterionId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `criterion_name` VARCHAR(100) NOT NULL,
  `criterion_description` LONGTEXT NULL,
  `criterion_type` TINYINT UNSIGNED NOT NULL,
  `qs_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Set to ''0'' if not qualification standard',
  `item_score` FLOAT NULL COMMENT 'If criteria item has a fixed score if selected.',
  `min` FLOAT NULL,
  `max` FLOAT NULL,
  `ceiling` FLOAT NULL,
  `weight` FLOAT NULL,
  `contributor` TINYINT NULL DEFAULT 0 COMMENT 'Mark true if criteria may be shared by multiple contributors. Use case in outstanding accomplishments',
  `selection` TINYINT NULL DEFAULT 0 COMMENT 'Mark if sub-items of criteria are options.',
  `parent_criteriaId` BIGINT UNSIGNED NULL COMMENT 'When NULL, this record represents a criteria set',
  PRIMARY KEY (`criterionId`),
  KEY `fk_RSP_Criterion_ENUM_QS_Type1_idx` (`qs_type`),
  KEY `fk_RSP_Criterion_ENUM_Criterion_Type1_idx` (`criterion_type`),
  CONSTRAINT `fk_RSP_Criterion_ENUM_QS_Type1` FOREIGN KEY (`qs_type`) REFERENCES `ENUM_QS_Type` (`qs_type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RSP_Criterion_ENUM_Criterion_Type1` FOREIGN KEY (`criterion_type`) REFERENCES `ENUM_Criterion_Type` (`criterion_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `ENUM_Award_Type` (
  `award_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(45) NULL,
  `cycle` TINYINT NULL COMMENT 'Will not use time units shorter than a ''day''',
  PRIMARY KEY (`award_type`),
  KEY `fk_ENUM_Award_Type_ENUM_Time_Unit1_idx` (`cycle`),
  CONSTRAINT `fk_ENUM_Award_Type_ENUM_Time_Unit1` FOREIGN KEY (`cycle`) REFERENCES `ENUM_Time_Unit` (`time_unit`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Values above 2 will  not be available to regular users
0: Not specified
1: Academic
2: Non-Academic
...';

CREATE TABLE `ENUM_Competency` (
  `competency` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  `competency_type` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`competency`),
  KEY `fk_ENUM_Competency_ENUM_Competency_Type1_idx` (`competency_type`),
  CONSTRAINT `fk_ENUM_Competency_ENUM_Competency_Type1` FOREIGN KEY (`competency_type`) REFERENCES `ENUM_Competency_Type` (`competency_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `ENUM_PPST_Strand` (
  `ppst_strand` FLOAT UNSIGNED NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `description` LONGTEXT NULL,
  `ppst_domain` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`ppst_strand`),
  KEY `fk_ENUM_PPST_Strand_ENUM_PPST_Domain1_idx` (`ppst_domain`),
  CONSTRAINT `fk_ENUM_PPST_Strand_ENUM_PPST_Domain1` FOREIGN KEY (`ppst_domain`) REFERENCES `ENUM_PPST_Domain` (`ppst_domain`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `HR_Action_Request` (
  `hra_requestId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empno` VARCHAR(50) NOT NULL,
  `hr_action` TINYINT UNSIGNED NOT NULL,
  `effective_date` DATE NULL,
  `timestamp` TIMESTAMP_F NOT NULL,
  PRIMARY KEY (`hra_requestId`),
  KEY `fk_HR_Action_Request_Employee1_idx` (`empno`),
  KEY `fk_HR_Action_Request_ENUM_HR_Action1_idx` (`hr_action`),
  CONSTRAINT `fk_HR_Action_Request_Employee1` FOREIGN KEY (`empno`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HR_Action_Request_ENUM_HR_Action1` FOREIGN KEY (`hr_action`) REFERENCES `ENUM_HR_Action` (`hr_action`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `KRA_Domain` (
  `kraId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `kra` VARCHAR(255) NOT NULL,
  `description` LONGTEXT NULL,
  `mfoId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`kraId`),
  KEY `fk_KRA_Domain_MFO1_idx` (`mfoId`),
  CONSTRAINT `fk_KRA_Domain_MFO1` FOREIGN KEY (`mfoId`) REFERENCES `MFO` (`mfoId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Key Result Area/Domain';

CREATE TABLE `LD_Program` (
  `ld_programId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `proponent` VARCHAR(50) NULL COMMENT 'Employee number of proponent',
  `description` LONGTEXT NULL,
  `start_date` DATE NULL COMMENT 'Blank dates indicates tentative activity
=Na',
  `end_date` DATE NULL,
  `duration` FLOAT UNSIGNED NULL,
  `time_unit` TINYINT UNSIGNED NULL,
  `venue` VARCHAR(100) NULL,
  `target_participants_description` LONGTEXT NULL,
  PRIMARY KEY (`ld_programId`),
  KEY `fk_LD_Program_ENUM_Time_Unit1_idx` (`time_unit`),
  CONSTRAINT `fk_LD_Program_ENUM_Time_Unit1` FOREIGN KEY (`time_unit`) REFERENCES `ENUM_Time_Unit` (`time_unit`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Location` (
  `locationId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `location_name` VARCHAR(255) NOT NULL,
  `location_type` INT UNSIGNED NOT NULL,
  `latitude` DECIMAL(10,8) NULL,
  `longitude` DECIMAL(11,8) NULL,
  PRIMARY KEY (`locationId`),
  KEY `fk_Location_ENUM_Location_Type1_idx` (`location_type`),
  CONSTRAINT `fk_Location_ENUM_Location_Type1` FOREIGN KEY (`location_type`) REFERENCES `ENUM_Location_Type` (`location_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `PM_Cycle` (
  `pm_cycleId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pm_cycle_name` VARCHAR(200) NOT NULL COMMENT 'Can be autogenerated from cycle parameters, but may be modified afterwards',
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `initiator` VARCHAR(50) NOT NULL COMMENT 'Employee number',
  `timestamp` TIMESTAMP_F NOT NULL,
  PRIMARY KEY (`pm_cycleId`),
  KEY `fk_PM_Cycle_Employee1_idx` (`initiator`),
  CONSTRAINT `fk_PM_Cycle_Employee1` FOREIGN KEY (`initiator`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `RSP_Cycle` (
  `rsp_cycleId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT 'If no name is specified, a name will be generated from the vacant position metadata',
  `initiated` DATETIME NOT NULL,
  `rsp_level` TINYINT UNSIGNED NOT NULL,
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`rsp_cycleId`),
  KEY `fk_RSP_Cycle_ENUM_RSP_Level1_idx` (`rsp_level`),
  CONSTRAINT `fk_RSP_Cycle_ENUM_RSP_Level1` FOREIGN KEY (`rsp_level`) REFERENCES `ENUM_RSP_Level` (`rsp_level`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='This will allow the setup of timelines, the assignment of RSP teams, and the bundling of vacancies of similar positions into RSP cycles. It is recommended that different position categories be assigned to different cycles to ensure the alignment of evaluator expertise to the applicant qualifications.';

CREATE TABLE `RSP_Increment_Level` (
  `incrementId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `qs_type` TINYINT UNSIGNED NOT NULL,
  `increment_level` TINYINT UNSIGNED NOT NULL,
  `from` VARCHAR(100) NOT NULL,
  `to` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`incrementId`),
  KEY `fk_RSP_Increment_ENUM_QS_Type1_idx` (`qs_type`),
  CONSTRAINT `fk_RSP_Increment_ENUM_QS_Type1` FOREIGN KEY (`qs_type`) REFERENCES `ENUM_QS_Type` (`qs_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `RSP_Increment_Rubric` (
  `inc_rubricId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `position_category` TINYINT UNSIGNED NOT NULL,
  `min_sg` TINYINT UNSIGNED NOT NULL,
  `max_sg` TINYINT UNSIGNED NOT NULL,
  `min_increment_level` TINYINT UNSIGNED NOT NULL,
  `max_increment_level` TINYINT UNSIGNED NOT NULL,
  `points` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`inc_rubricId`),
  KEY `fk_RSP_Increment_Rubric_ENUM_Position_Category1_idx` (`position_category`),
  CONSTRAINT `fk_RSP_Increment_Rubric_ENUM_Position_Category1` FOREIGN KEY (`position_category`) REFERENCES `ENUM_Position_Category` (`position_category`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Role_Right` (
  `roleId` BIGINT UNSIGNED NOT NULL,
  `rightId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`roleId`, `rightId`),
  KEY `fk_Role_Right_Role1_idx` (`roleId`),
  KEY `fk_Role_Right_Right1_idx` (`rightId`),
  CONSTRAINT `fk_Role_Right_Role1` FOREIGN KEY (`roleId`) REFERENCES `Role` (`roleId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_Role_Right_Right1` FOREIGN KEY (`rightId`) REFERENCES `Right` (`rightId`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Team_Member` (
  `memberId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empno` VARCHAR(50) NOT NULL,
  `teamId` INT UNSIGNED NOT NULL,
  `team_role` BIGINT UNSIGNED NOT NULL,
  `assigned` DATETIME NULL,
  `removed` DATETIME NULL,
  PRIMARY KEY (`memberId`),
  KEY `fk_Team_Member_Employee1_idx` (`empno`),
  KEY `fk_Team_Member_ENUM_Team_Role1_idx` (`team_role`),
  KEY `fk_Team_Member_Team1_idx` (`teamId`),
  CONSTRAINT `fk_Team_Member_Employee1` FOREIGN KEY (`empno`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Team_Member_ENUM_Team_Role1` FOREIGN KEY (`team_role`) REFERENCES `?` (`team_role`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Team_Member_Team1` FOREIGN KEY (`teamId`) REFERENCES `?` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Address` (
  `addressId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `address` LONGTEXT NOT NULL,
  `locationId` BIGINT UNSIGNED NULL,
  `location_type` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`addressId`),
  KEY `fk_Address_ENUM_Location_Type1_idx` (`location_type`),
  KEY `fk_Address_Location1_idx` (`locationId`),
  CONSTRAINT `fk_Address_ENUM_Location_Type1` FOREIGN KEY (`location_type`) REFERENCES `ENUM_Location_Type` (`location_type`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Address_Location1` FOREIGN KEY (`locationId`) REFERENCES `Location` (`locationId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `ENUM_Competency_Indicator` (
  `competency_indicator` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  `competency` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`competency_indicator`),
  KEY `fk_ENUM_PM_Competency_ENUM_PM_Competency_Indicator1_idx` (`competency`),
  CONSTRAINT `fk_ENUM_PM_Competency_ENUM_PM_Competency_Indicator1` FOREIGN KEY (`competency`) REFERENCES `ENUM_Competency` (`competency`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Suggested values for DepEd
0: Not specified
1: Self-Management
2: Professionalism and Ethics
3: Results Focus
4: Teamwork
5: Service Orientation
6: Innovation
7: Gender Sensitivity
...';

CREATE TABLE `ENUM_PPST_Indicator` (
  `ppst_indicator` VARCHAR(10) NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `description` LONGTEXT NULL,
  `ppst_strand` FLOAT UNSIGNED NOT NULL,
  `career_stage` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`ppst_indicator`),
  KEY `fk_ENUM_PPST_Indicator_ENUM_PPST_Strand1_idx` (`ppst_strand`),
  KEY `fk_ENUM_PPST_Indicator_ENUM_Teacher_Career_Stage1_idx` (`career_stage`),
  CONSTRAINT `fk_ENUM_PPST_Indicator_ENUM_PPST_Strand1` FOREIGN KEY (`ppst_strand`) REFERENCES `ENUM_PPST_Strand` (`ppst_strand`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ENUM_PPST_Indicator_ENUM_Teacher_Career_Stage1` FOREIGN KEY (`career_stage`) REFERENCES `ENUM_Teacher_Career_Stage` (`career_stage`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Nominee_Score` (
  `scoreId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nominee_evaluationId` INT UNSIGNED NOT NULL,
  `criterionId` BIGINT UNSIGNED NOT NULL,
  `raw_score` FLOAT NULL,
  `max` FLOAT NULL COMMENT 'Ignores max in criterion of this is defined',
  `final_score` FLOAT NULL COMMENT 'Required for finalized CAR',
  PRIMARY KEY (`scoreId`),
  KEY `fk_Nominee_Score_Criterion1_idx` (`criterionId`),
  KEY `fk_Nominee_Score_Nominee_Evaluation1_idx` (`nominee_evaluationId`),
  CONSTRAINT `fk_Nominee_Score_Criterion1` FOREIGN KEY (`criterionId`) REFERENCES `Criterion` (`criterionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nominee_Score_Nominee_Evaluation1` FOREIGN KEY (`nominee_evaluationId`) REFERENCES `?` (`nominee_evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `PM_Coaching_Session` (
  `coaching_sessionId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empno` VARCHAR(50) NOT NULL,
  `pm_cycleId` BIGINT UNSIGNED NOT NULL,
  `significant_incidents` VARCHAR(1000) NOT NULL,
  `impact` VARCHAR(1000) NOT NULL,
  `feedback` VARCHAR(1000) NOT NULL,
  `progress` VARCHAR(45) NOT NULL,
  `conducted_on` DATE NULL,
  `concurred_on` DATE NULL,
  `approved_on` DATE NULL,
  PRIMARY KEY (`coaching_sessionId`),
  KEY `fk_PM_Coaching_Session_PM_Cycle1_idx` (`pm_cycleId`),
  KEY `fk_PM_Coaching_Session_Employee1_idx` (`empno`),
  CONSTRAINT `fk_PM_Coaching_Session_PM_Cycle1` FOREIGN KEY (`pm_cycleId`) REFERENCES `PM_Cycle` (`pm_cycleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Coaching_Session_Employee1` FOREIGN KEY (`empno`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `PM_Role` (
  `pm_roleId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pm_role` TINYINT UNSIGNED NOT NULL,
  `pm_cyceId` BIGINT UNSIGNED NOT NULL,
  `empno` VARCHAR(50) NOT NULL,
  `org_level` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`pm_roleId`),
  KEY `fk_PM_Role_ENUM_PM_Role1_idx` (`pm_role`),
  KEY `fk_PM_Role_PM_Cycle1_idx` (`pm_cyceId`),
  KEY `fk_PM_Role_Employee1_idx` (`empno`),
  KEY `fk_PM_Role_ENUM_Org_Level1_idx` (`org_level`),
  CONSTRAINT `fk_PM_Role_ENUM_PM_Role1` FOREIGN KEY (`pm_role`) REFERENCES `ENUM_PM_Role` (`pm_role`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Role_PM_Cycle1` FOREIGN KEY (`pm_cyceId`) REFERENCES `PM_Cycle` (`pm_cycleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Role_Employee1` FOREIGN KEY (`empno`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Role_ENUM_Org_Level1` FOREIGN KEY (`org_level`) REFERENCES `ENUM_Org_Level` (`org_level`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Should be assigned before performance management is planned
';

CREATE TABLE `RSP_Phase` (
  `rsp_phaseId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rsp_cycleId` BIGINT UNSIGNED NOT NULL,
  `rsp_phase` TINYINT UNSIGNED NOT NULL,
  `target_start` DATE NOT NULL,
  `target_end` DATE NOT NULL,
  `actual_start` DATE NULL,
  `actual_end` DATE NULL COMMENT 'For cycles with multiple vacancies, encode this date only when ALL vacancies in the cycle have already completed this phase.',
  `extended` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `ier` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Mark if result of phase is an IER or a shortlist of qualified applicants. If marked as TRUE, finalization of IER triggers the actual end of this phase.',
  `car` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Mark if result of phase is a CAR or a ranked list of applicants. If marked as TRUE, finalization of CAR triggers the actual end of this phase.',
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`rsp_phaseId`),
  KEY `fk_RSP_Phase_ENUM_RSP_Phase1_idx` (`rsp_phase`),
  KEY `fk_RSP_Phase_RSP_Cycle1_idx` (`rsp_cycleId`),
  CONSTRAINT `fk_RSP_Phase_ENUM_RSP_Phase1` FOREIGN KEY (`rsp_phase`) REFERENCES `ENUM_RSP_Phase` (`rsp_phase`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RSP_Phase_RSP_Cycle1` FOREIGN KEY (`rsp_cycleId`) REFERENCES `RSP_Cycle` (`rsp_cycleId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `RSP_Team` (
  `rsp_teamId` BIGINT UNSIGNED NOT NULL,
  `rsp_cycleId` BIGINT UNSIGNED NOT NULL,
  `teamId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`rsp_teamId`),
  KEY `fk_RSP_Team_RSP_Cycle1_idx` (`rsp_cycleId`),
  KEY `fk_RSP_Team_Team1_idx` (`teamId`),
  CONSTRAINT `fk_RSP_Team_RSP_Cycle1` FOREIGN KEY (`rsp_cycleId`) REFERENCES `RSP_Cycle` (`rsp_cycleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RSP_Team_Team1` FOREIGN KEY (`teamId`) REFERENCES `?` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Sponsored_Award` (
  `sponsored_awardId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `award_name` VARCHAR(255) NOT NULL,
  `cycle_start` DATE NULL COMMENT 'Start date of award cycle',
  `cycle_end` DATE NULL,
  `award_type` INT NOT NULL,
  `remarks` LONGTEXT NULL,
  `criterionId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`sponsored_awardId`),
  KEY `fk_Sponsored_Award_ENUM_Award_Type1_idx` (`award_type`),
  KEY `fk_Sponsored_Award_Criterion1_idx` (`criterionId`),
  CONSTRAINT `fk_Sponsored_Award_ENUM_Award_Type1` FOREIGN KEY (`award_type`) REFERENCES `ENUM_Award_Type` (`award_type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sponsored_Award_Criterion1` FOREIGN KEY (`criterionId`) REFERENCES `Criterion` (`criterionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Award cycle is defined in award type';

CREATE TABLE `COT_Indicator` (
  `coiId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `classroom_observationId` VARCHAR(45) NOT NULL,
  `coi` VARCHAR(10) NOT NULL,
  `score` TINYINT NULL COMMENT 'Will be based on levels set in ENUM_PPST_Rubric',
  PRIMARY KEY (`coiId`),
  KEY `fk_CO_Indicator_Classroom_Observation1_idx` (`classroom_observationId`),
  KEY `fk_CO_Indicator_ENUM_PPST_Indicator1_idx` (`coi`),
  CONSTRAINT `fk_CO_Indicator_Classroom_Observation1` FOREIGN KEY (`classroom_observationId`) REFERENCES `?` (`classroom_observationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CO_Indicator_ENUM_PPST_Indicator1` FOREIGN KEY (`coi`) REFERENCES `ENUM_PPST_Indicator` (`ppst_indicator`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Duty` (
  `dutyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `duty` VARCHAR(1000) NOT NULL COMMENT 'A duty statement shall be imperative, using the base form of verbs. If PPST indicator is identified, duty should match the said indicator.',
  `description` LONGTEXT NULL,
  `parent_dutyId` BIGINT UNSIGNED NULL,
  `kraId` BIGINT UNSIGNED NULL,
  `ppst_indicator` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`dutyId`, `ppst_indicator`),
  KEY `fk_SELF1_idx` (`parent_dutyId`),
  KEY `fk_Duty_KRA_Domain1_idx` (`kraId`),
  KEY `fk_Duty_ENUM_PPST_Indicator1_idx` (`ppst_indicator`),
  CONSTRAINT `fk_SELF1` FOREIGN KEY (`parent_dutyId`) REFERENCES `Duty` (`dutyId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_Duty_KRA_Domain1` FOREIGN KEY (`kraId`) REFERENCES `KRA_Domain` (`kraId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Duty_ENUM_PPST_Indicator1` FOREIGN KEY (`ppst_indicator`) REFERENCES `ENUM_PPST_Indicator` (`ppst_indicator`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Duties and responsibilities';

CREATE TABLE `ENUM_PPST_Rubric` (
  `rubric` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ppst_indicator` VARCHAR(10) NOT NULL,
  `ppst_indicator_level` TINYINT NOT NULL,
  `description` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`rubric`),
  KEY `fk_COT_Rubric_ENUM_PPST_Indicator1_idx` (`ppst_indicator`),
  CONSTRAINT `fk_COT_Rubric_ENUM_PPST_Indicator1` FOREIGN KEY (`ppst_indicator`) REFERENCES `ENUM_PPST_Indicator` (`ppst_indicator`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Organization` (
  `orgId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `org_name` VARCHAR(255) NOT NULL,
  `addressId` BIGINT UNSIGNED NULL,
  `org_description` LONGTEXT NULL,
  `org_type` TINYINT UNSIGNED NULL COMMENT 'For LGUs, this shall be used to identify the governmental unit type',
  `org_level` TINYINT UNSIGNED NULL COMMENT 'Use this field for organizational hierarchies',
  `lgu_class` TINYINT UNSIGNED NULL COMMENT 'For LGU use only:
0: Special
1: 1st Class
2: 2nd Class
3: 3rd Class
4: 4th Class
5: 5th Class
6: 6th Class',
  `dbm_org_code` VARCHAR(15) NULL COMMENT 'Plantilla Organization Code from PSIPOP',
  `dbm_org_desc` VARCHAR(200) NULL COMMENT 'Plantilla Organization Description from PSIPOP',
  `payroll_org_code` VARCHAR(10) NULL,
  `payroll_org_name` VARCHAR(30) NULL,
  `parent_orgId` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`orgId`),
  KEY `fk_Organization_ENUM_Org_Type1_idx` (`org_type`),
  KEY `fk_Organization_ENUM_Org_Level1_idx` (`org_level`),
  KEY `fk_Organization_Address1_idx` (`addressId`),
  KEY `fk_Self1_idx` (`parent_orgId`),
  CONSTRAINT `fk_Organization_ENUM_Org_Type1` FOREIGN KEY (`org_type`) REFERENCES `ENUM_Org_Type` (`org_type`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_Organization_ENUM_Org_Level1` FOREIGN KEY (`org_level`) REFERENCES `ENUM_Org_Level` (`org_level`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_Organization_Address1` FOREIGN KEY (`addressId`) REFERENCES `Address` (`addressId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Self1` FOREIGN KEY (`parent_orgId`) REFERENCES `Organization` (`orgId`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='This shall represent data on Organizational Units; May include both internal units and external organizations';

CREATE TABLE `PM_Coaching_Mechanism` (
  `coaching_mechanismId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `coaching_sessionId` BIGINT UNSIGNED NOT NULL,
  `coaching_mechanism` INT UNSIGNED NOT NULL,
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`coaching_mechanismId`),
  KEY `fk_PM_Coaching_Mechanism_PM_Coaching_Session1_idx` (`coaching_sessionId`),
  KEY `fk_PM_Coaching_Mechanism_ENUM_Coaching_Mechanism1_idx` (`coaching_mechanism`),
  CONSTRAINT `fk_PM_Coaching_Mechanism_PM_Coaching_Session1` FOREIGN KEY (`coaching_sessionId`) REFERENCES `PM_Coaching_Session` (`coaching_sessionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Coaching_Mechanism_ENUM_Coaching_Mechanism1` FOREIGN KEY (`coaching_mechanism`) REFERENCES `ENUM_Coaching_Mechanism` (`coaching_mechanism`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Performance` (
  `performanceId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empno` VARCHAR(50) NOT NULL,
  `pm_cycleId` BIGINT UNSIGNED NOT NULL,
  `start_date` DATE NOT NULL COMMENT 'The same as start date in PM cycle, but may vary depending on actual start',
  `end_date` DATE NOT NULL COMMENT 'The same as end date in PM Cycle, but may be changed later on',
  `rater` BIGINT UNSIGNED NOT NULL,
  `approver` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`performanceId`),
  KEY `fk_Performance_Employee1_idx` (`empno`),
  KEY `fk_Performance_PM_Cycle1_idx` (`pm_cycleId`),
  KEY `fk_Performance_PM_Role1_idx` (`rater`),
  KEY `fk_Performance_PM_Role2_idx` (`approver`),
  CONSTRAINT `fk_Performance_Employee1` FOREIGN KEY (`empno`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performance_PM_Cycle1` FOREIGN KEY (`pm_cycleId`) REFERENCES `PM_Cycle` (`pm_cycleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performance_PM_Role1` FOREIGN KEY (`rater`) REFERENCES `PM_Role` (`pm_roleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performance_PM_Role2` FOREIGN KEY (`approver`) REFERENCES `PM_Role` (`pm_roleId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Person` (
  `personId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `given_name` VARCHAR(100) NOT NULL COMMENT 'A person should have at least a given name',
  `middle_name` VARCHAR(100) NULL,
  `family_name` VARCHAR(100) NULL,
  `spouse_name` VARCHAR(100) NULL,
  `ext_name` VARCHAR(30) NULL,
  `birthday` DATE NULL,
  `birthplace` BIGINT UNSIGNED NULL,
  `age` TINYINT UNSIGNED NULL COMMENT 'will be updated accordingly if birthday is present',
  `present_addressId` BIGINT UNSIGNED NULL,
  `permanent_addressId` BIGINT UNSIGNED NULL,
  `sex` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Note: Sex assigned at birth or through jurisprudence
0/NULL: Unspecified
1: Male
2: Female
...',
  `civil_status` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `height` FLOAT UNSIGNED NULL,
  `weight` FLOAT UNSIGNED NULL,
  `blood_type` VARCHAR(45) NULL,
  PRIMARY KEY (`personId`),
  KEY `fk_Person_ENUM_Sex1_idx` (`sex`),
  KEY `fk_Person_ENUM_Civil_Status1_idx` (`civil_status`),
  KEY `fk_Person_Address1_idx` (`birthplace`),
  KEY `fk_Person_Address2_idx` (`present_addressId`),
  KEY `fk_Person_Address3_idx` (`permanent_addressId`),
  CONSTRAINT `fk_Person_ENUM_Sex1` FOREIGN KEY (`sex`) REFERENCES `ENUM_Sex` (`sex`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Person_ENUM_Civil_Status1` FOREIGN KEY (`civil_status`) REFERENCES `ENUM_Civil_Status` (`civil_status`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Person_Address1` FOREIGN KEY (`birthplace`) REFERENCES `Address` (`addressId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_Person_Address2` FOREIGN KEY (`present_addressId`) REFERENCES `Address` (`addressId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_Person_Address3` FOREIGN KEY (`permanent_addressId`) REFERENCES `Address` (`addressId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `RR_Team` (
  `rr_teamId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sponsored_awardId` BIGINT UNSIGNED NOT NULL,
  `teamId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`rr_teamId`),
  KEY `fk_RR_Team_Sponsored_Award1_idx` (`sponsored_awardId`),
  KEY `fk_RR_Team_Team1_idx` (`teamId`),
  CONSTRAINT `fk_RR_Team_Sponsored_Award1` FOREIGN KEY (`sponsored_awardId`) REFERENCES `Sponsored_Award` (`sponsored_awardId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RR_Team_Team1` FOREIGN KEY (`teamId`) REFERENCES `?` (`teamId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Award` (
  `awardId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `award_name` VARCHAR(255) NOT NULL,
  `sponsorId` BIGINT UNSIGNED NULL COMMENT 'Award sponsor/award-giving body',
  `award_type` INT UNSIGNED NOT NULL,
  `personId` BIGINT UNSIGNED NOT NULL COMMENT 'Awardee; null if award still has no recipient',
  `date_awarded` DATE NULL,
  `remarks` LONGTEXT NULL,
  `sponsored_awardId` BIGINT UNSIGNED NULL COMMENT 'Non-null columns signify HRM-sponsored awards. HRM-sppnsored awards (awards sponsored or sanctioned by the Division PRAISE Committee) cannot be modified or deleted by regular users. These can only be modified by the HRMO and the PRAISE Committee. Deletion of an HRM-sponsored award needs the approval of the HRMO.',
  PRIMARY KEY (`awardId`),
  KEY `fk_Award_Organization1_idx` (`sponsorId`),
  KEY `fk_Award_ENUM_Award_Type1_idx` (`award_type`),
  KEY `fk_Award_Sponsored_Award1_idx` (`sponsored_awardId`),
  KEY `fk_Award_Person1_idx` (`personId`),
  CONSTRAINT `fk_Award_Organization1` FOREIGN KEY (`sponsorId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Award_ENUM_Award_Type1` FOREIGN KEY (`award_type`) REFERENCES `ENUM_Award_Type` (`award_type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Award_Sponsored_Award1` FOREIGN KEY (`sponsored_awardId`) REFERENCES `Sponsored_Award` (`sponsored_awardId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Award_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Character_Reference` (
  `chrefId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personId` BIGINT UNSIGNED NOT NULL,
  `ref_personId` BIGINT UNSIGNED NOT NULL,
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`chrefId`),
  KEY `fk_Character_Reference_Person1_idx` (`personId`),
  KEY `fk_Character_Reference_Person2_idx` (`ref_personId`),
  CONSTRAINT `fk_Character_Reference_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Character_Reference_Person2` FOREIGN KEY (`ref_personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Citizenship` (
  `chrefId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personId` BIGINT UNSIGNED NOT NULL,
  `countryId` BIGINT UNSIGNED NOT NULL COMMENT 'Only use country IDs for this field',
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`chrefId`),
  KEY `fk_Citizenship_Person1_idx` (`personId`),
  KEY `fk_Citizenship_Location1_idx` (`countryId`),
  CONSTRAINT `fk_Citizenship_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Citizenship_Location1` FOREIGN KEY (`countryId`) REFERENCES `Location` (`locationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Disability` (
  `disabilityId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personId` BIGINT UNSIGNED NOT NULL,
  `disability_type` INT UNSIGNED NOT NULL,
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`disabilityId`),
  KEY `fk_Disability_Person1_idx` (`personId`),
  KEY `fk_Disability_ENUM_Disability_Type1_idx` (`disability_type`),
  CONSTRAINT `fk_Disability_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Disability_ENUM_Disability_Type1` FOREIGN KEY (`disability_type`) REFERENCES `ENUM_Disability_Type` (`disability_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Education` (
  `educId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `educ_level` INT UNSIGNED NOT NULL,
  `program_name` VARCHAR(200) NULL,
  `school_name` VARCHAR(300) NOT NULL,
  `start_date` DATE NULL,
  `level_completed` VARCHAR(10) NULL,
  `unit_earned` TINYINT UNSIGNED NULL,
  `graduation_date` DATE NULL,
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`educId`),
  KEY `fk_Educational_Attainment_ENUM_Educ_Level1_idx` (`educ_level`),
  KEY `fk_Educational_Attainment_Person1_idx` (`personId`),
  KEY `fk_Education_ENUM_Year_Level_Completed1_idx` (`level_completed`),
  CONSTRAINT `fk_Educational_Attainment_ENUM_Educ_Level1` FOREIGN KEY (`educ_level`) REFERENCES `ENUM_Educ_Level` (`educ_level`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Educational_Attainment_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Education_ENUM_Year_Level_Completed1` FOREIGN KEY (`level_completed`) REFERENCES `ENUM_Year_Level_Completed` (`level_completed`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Eligibility` (
  `eligibilityId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `eligibility_type` INT UNSIGNED NOT NULL,
  `rating` FLOAT UNSIGNED NULL,
  `date_conferred` DATE NOT NULL,
  `place_conferred` VARCHAR(100) NOT NULL COMMENT 'Place of examination or conferment',
  `license_num` VARCHAR(100) NULL COMMENT 'For RA 1080 and other eligibilities with licenses',
  `license_expiration` DATE NULL COMMENT 'For RA 1080 and other eligibilities with licenses',
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`eligibilityId`),
  KEY `fk_Eligibility_Person1_idx` (`personId`),
  KEY `fk_Eligibility_ENUM_Eligibility_Type1_idx` (`eligibility_type`),
  CONSTRAINT `fk_Eligibility_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Eligibility_ENUM_Eligibility_Type1` FOREIGN KEY (`eligibility_type`) REFERENCES `ENUM_Eligibility_Type` (`eligibility_type`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Email_Address` (
  `email_addressId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Added to allow the same email address to be assigned to multiple persons',
  `email_address` VARCHAR(250) NOT NULL,
  `personId` BIGINT UNSIGNED NOT NULL COMMENT 'Use for individuals',
  `orgId` BIGINT UNSIGNED NULL COMMENT 'Use for organizations (institutions, offices, etc.)',
  PRIMARY KEY (`email_addressId`),
  KEY `fk_Email_Address_Person_idx` (`personId`),
  KEY `fk_Email_Address_Organization1_idx` (`orgId`),
  CONSTRAINT `fk_Email_Address_Person` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Email_Address_Organization1` FOREIGN KEY (`orgId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Hobby` (
  `hobbyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `hobby` VARCHAR(200) NOT NULL,
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`hobbyId`),
  KEY `fk_Hobby_Person1_idx` (`personId`),
  CONSTRAINT `fk_Hobby_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Identification` (
  `idIndex` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` VARCHAR(50) NOT NULL COMMENT 'Note: Actual ID number',
  `id_type` INT UNSIGNED NOT NULL DEFAULT 0,
  `issued` DATE NULL,
  `expired` DATE NULL,
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`idIndex`),
  KEY `fk_Identification_Person1_idx` (`personId`),
  KEY `fk_Identification_ENUM_ID_Type1_idx` (`id_type`),
  CONSTRAINT `fk_Identification_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Identification_ENUM_ID_Type1` FOREIGN KEY (`id_type`) REFERENCES `ENUM_ID_Type` (`id_type`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Implementing_Unit` (
  `implementing_unitId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `orgId` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`implementing_unitId`),
  KEY `fk_Implementing_Unit_Organization1_idx` (`orgId`),
  CONSTRAINT `fk_Implementing_Unit_Organization1` FOREIGN KEY (`orgId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='For DepEd only';

CREATE TABLE `LD_Recipient` (
  `ld_recipientId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personId` BIGINT UNSIGNED NOT NULL COMMENT 'L&D is connected to person data instead of employee data to ensure continuity of training records in case of changes in employee number.',
  `ld_programId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ld_recipientId`),
  KEY `fk_LD_Recipient_LD_Program1_idx` (`ld_programId`),
  KEY `fk_LD_Recipient_Person1_idx` (`personId`),
  CONSTRAINT `fk_LD_Recipient_LD_Program1` FOREIGN KEY (`ld_programId`) REFERENCES `?` (`ld_programId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_LD_Recipient_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Membership` (
  `membershipId` BIGINT NOT NULL,
  `role` VARCHAR(255) NOT NULL,
  `orgId` BIGINT UNSIGNED NOT NULL,
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`membershipId`),
  KEY `fk_Membership_Organization1_idx` (`orgId`),
  KEY `fk_Membership_Person1_idx` (`personId`),
  CONSTRAINT `fk_Membership_Organization1` FOREIGN KEY (`orgId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Membership_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Membership in associations and organizations. Do not use for employment engagemtn or affiliations.';

CREATE TABLE `Nominee` (
  `nomineeId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personId` BIGINT UNSIGNED NOT NULL COMMENT 'A nominee can also be a non-employee. Likewise, connecting the nominee to person data rather that employee data will ensure continuity in case of changes to employee number.',
  `sponsored_awardId` BIGINT UNSIGNED NOT NULL,
  `isAwardee` TINYINT NOT NULL DEFAULT 0 COMMENT 'Mark as TRUE when nominee is selected as an awardee.',
  PRIMARY KEY (`nomineeId`),
  KEY `fk_Nominee_Sponsored_Award1_idx` (`sponsored_awardId`),
  KEY `fk_Nominee_Person1_idx` (`personId`),
  CONSTRAINT `fk_Nominee_Sponsored_Award1` FOREIGN KEY (`sponsored_awardId`) REFERENCES `Sponsored_Award` (`sponsored_awardId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nominee_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `PM_Classroom_Observation` (
  `pm_coId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `performanceId` BIGINT NOT NULL,
  `classroom_observationId` BIGINT NOT NULL,
  PRIMARY KEY (`pm_coId`),
  KEY `fk_PM_Classroom_Observation_Performance1_idx` (`performanceId`),
  KEY `fk_PM_Classroom_Observation_Classroom_Observation1_idx` (`classroom_observationId`),
  CONSTRAINT `fk_PM_Classroom_Observation_Performance1` FOREIGN KEY (`performanceId`) REFERENCES `Performance` (`performanceId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Classroom_Observation_Classroom_Observation1` FOREIGN KEY (`classroom_observationId`) REFERENCES `?` (`classroom_observationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `PM_Competency_Indicator` (
  `pm_competency_indicatorId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `competency_indicator` BIGINT UNSIGNED NOT NULL,
  `score` TINYINT UNSIGNED NULL COMMENT 'A score from 1 to 5 signifying the achievement of indicator. Given at the end of a performance cycle',
  `performanceId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`pm_competency_indicatorId`),
  KEY `fk_PM_Competency_ENUM_PM_Competency1_idx` (`competency_indicator`),
  KEY `fk_PM_Competency_Indicator_Performance1_idx` (`performanceId`),
  CONSTRAINT `fk_PM_Competency_ENUM_PM_Competency1` FOREIGN KEY (`competency_indicator`) REFERENCES `ENUM_Competency_Indicator` (`competency_indicator`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Competency_Indicator_Performance1` FOREIGN KEY (`performanceId`) REFERENCES `Performance` (`performanceId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Performance_History` (
  `performance_historyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `performanceId` BIGINT UNSIGNED NOT NULL,
  `pm_action` TINYINT UNSIGNED NOT NULL,
  `timestamp` TIMESTAMP_F NOT NULL,
  `empno` VARCHAR(50) NOT NULL COMMENT 'Who performed action',
  `pm_role` TINYINT UNSIGNED NOT NULL,
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`performance_historyId`),
  KEY `fk_Performance_History_Performance1_idx` (`performanceId`),
  KEY `fk_Performance_History_ENUM_PM_Action1_idx` (`pm_action`),
  KEY `fk_Performance_History_Employee1_idx` (`empno`),
  KEY `fk_Performance_History_ENUM_PM_Role1_idx` (`pm_role`),
  CONSTRAINT `fk_Performance_History_Performance1` FOREIGN KEY (`performanceId`) REFERENCES `Performance` (`performanceId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performance_History_ENUM_PM_Action1` FOREIGN KEY (`pm_action`) REFERENCES `ENUM_PM_Action` (`pm_action`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performance_History_Employee1` FOREIGN KEY (`empno`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performance_History_ENUM_PM_Role1` FOREIGN KEY (`pm_role`) REFERENCES `ENUM_PM_Role` (`pm_role`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Performance_Objective` (
  `performance_objectiveId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `dutyId` BIGINT UNSIGNED NOT NULL,
  `objective` VARCHAR(1000) NOT NULL COMMENT 'By default, an objective in performance managementt shall be a restatement of the duty using the past tense. This may be modified when necessary. Multiple objectives may be added ',
  `performanceId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`performance_objectiveId`),
  KEY `fk_PM_Objective_Duty1_idx` (`dutyId`),
  KEY `fk_PM_Objective_Performance1_idx` (`performanceId`),
  CONSTRAINT `fk_PM_Objective_Duty1` FOREIGN KEY (`dutyId`) REFERENCES `Duty` (`dutyId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Objective_Performance1` FOREIGN KEY (`performanceId`) REFERENCES `Performance` (`performanceId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Phone_Number` (
  `phone_numberId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `phone_number` VARCHAR(50) NOT NULL,
  `phone_type` TINYINT UNSIGNED NOT NULL,
  `personId` BIGINT UNSIGNED NULL,
  `orgId` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`phone_numberId`),
  KEY `fk_Phone_Number_Person1_idx` (`personId`),
  KEY `fk_Phone_Number_ENUM_Phone_Type1_idx` (`phone_type`),
  KEY `fk_Phone_Number_Organization1_idx` (`orgId`),
  CONSTRAINT `fk_Phone_Number_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Phone_Number_ENUM_Phone_Type1` FOREIGN KEY (`phone_type`) REFERENCES `ENUM_Phone_Type` (`phone_type`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Phone_Number_Organization1` FOREIGN KEY (`orgId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Position` (
  `positionId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `position_title` VARCHAR(100) NOT NULL,
  `position_category` TINYINT UNSIGNED NULL,
  `position_code` VARCHAR(10) NULL COMMENT 'For payroll use',
  `orgId` BIGINT NULL COMMENT 'Use only for non-Plantilla positions',
  `engagement_term` TINYINT UNSIGNED NULL,
  `fund_source` TINYINT UNSIGNED NOT NULL,
  `salary_grade` TINYINT UNSIGNED NULL COMMENT 'Ignored when defined in Incumbency table',
  `salary` FLOAT UNSIGNED NULL COMMENT 'Computed from the step 1 of salary grade for Plantilla positions; ignored when defined in Incumbency table; value not used when salary grade is defined',
  `supervisorId` BIGINT UNSIGNED NULL,
  `remarks` LONGTEXT NULL,
  PRIMARY KEY (`positionId`),
  KEY `fk_Position_ENUM_Position_Classification1_idx` (`fund_source`),
  KEY `fk_Position_ENUM_Position_Category1_idx` (`position_category`),
  KEY `fk_Position_ENUM_Engagement_Term1_idx` (`engagement_term`),
  KEY `fk_Position_Organization1_idx` (`orgId`),
  KEY `fk_SELF1_idx` (`supervisorId`),
  CONSTRAINT `fk_Position_ENUM_Position_Classification1` FOREIGN KEY (`fund_source`) REFERENCES `ENUM_Fund_Source` (`position_classification`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Position_ENUM_Position_Category1` FOREIGN KEY (`position_category`) REFERENCES `ENUM_Position_Category` (`position_category`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Position_ENUM_Engagement_Term1` FOREIGN KEY (`engagement_term`) REFERENCES `ENUM_Engagement_Term` (`engagement_term`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Position_Organization1` FOREIGN KEY (`orgId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SELF1` FOREIGN KEY (`supervisorId`) REFERENCES `Position` (`positionId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Special_Skill` (
  `skillId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `skill` VARCHAR(200) NOT NULL,
  `proficiency` TINYINT UNSIGNED NULL COMMENT 'Self-rating from a scale of 1 to 10',
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`skillId`),
  KEY `fk_Special_Skill_Person1_idx` (`personId`),
  CONSTRAINT `fk_Special_Skill_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Training` (
  `trainingId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `training_title` VARCHAR(300) NOT NULL,
  `training_providerId` BIGINT UNSIGNED NULL COMMENT 'orgId; conductor or sponsor of training',
  `training_type` TINYINT UNSIGNED NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `duration` FLOAT UNSIGNED NULL COMMENT 'API should compute duration if start_date and end_date are provided using an 8 hours of training per day standard. It is recommended to always supply this data using the actual traiining certification.',
  `time_unit` TINYINT UNSIGNED NULL COMMENT 'Always encode with duration. Prefer hours, whenever possible',
  `cpd_units_earned` FLOAT NULL,
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  `ld_programId` INT UNSIGNED NULL COMMENT 'Used if Training is a Learning and Development initiative sponsored under the office.',
  PRIMARY KEY (`trainingId`),
  KEY `fk_Training_ENUM_Time_Unit1_idx` (`time_unit`),
  KEY `fk_Training_Person1_idx` (`personId`),
  KEY `fk_Training_ENUM_Training_Type1_idx` (`training_type`),
  KEY `fk_Training_LD_Program1_idx` (`ld_programId`),
  CONSTRAINT `fk_Training_ENUM_Time_Unit1` FOREIGN KEY (`time_unit`) REFERENCES `ENUM_Time_Unit` (`time_unit`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Training_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Training_ENUM_Training_Type1` FOREIGN KEY (`training_type`) REFERENCES `ENUM_Training_Type` (`training_type`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Training_LD_Program1` FOREIGN KEY (`ld_programId`) REFERENCES `?` (`ld_programId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `User` (
  `userId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(250) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `initial_login` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `personId` BIGINT UNSIGNED NOT NULL,
  `status` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `user_type` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `failed_attempts` INT UNSIGNED NOT NULL DEFAULT 0,
  `locked_until` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `uq_User_username` (`username`),
  KEY `fk_User_Person1_idx` (`personId`),
  KEY `fk_User_ENUM_User_Status_idx` (`status`),
  KEY `fk_User_ENUM_User_Type_idx` (`user_type`),
  CONSTRAINT `fk_User_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_User_ENUM_User_Status` FOREIGN KEY (`status`) REFERENCES `ENUM_User_Status` (`status`) ON DELETE RESTRICT ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_ENUM_User_Type` FOREIGN KEY (`user_type`) REFERENCES `ENUM_User_Type` (`user_type`) ON DELETE RESTRICT ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Voluntary_Work` (
  `voluntary_workId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nature_of_work` VARCHAR(255) NOT NULL,
  `orgId` BIGINT UNSIGNED NOT NULL COMMENT 'Organization record should have both name and address to comply with the corresponding PDS field.',
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL COMMENT 'No end_date shall mean unfinished status.',
  `number_of_hours` FLOAT NOT NULL COMMENT 'If unfinished, will use date of signing for end_date in reconning the number of hours. This shall not be automatically calculated',
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`voluntary_workId`),
  KEY `fk_Volutary_Work_Person1_idx` (`personId`),
  KEY `fk_Volutary_Work_Organization1_idx` (`orgId`),
  CONSTRAINT `fk_Volutary_Work_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Volutary_Work_Organization1` FOREIGN KEY (`orgId`) REFERENCES `Organization` (`orgId`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Work_Experience` (
  `work_expId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `position_title` VARCHAR(200) NOT NULL,
  `employerId` BIGINT UNSIGNED NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `employment_status` TINYINT UNSIGNED NOT NULL,
  `remarks` LONGTEXT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  `incumbencyId` BIGINT UNSIGNED NULL COMMENT 'refer to incumbency instead of empno',
  PRIMARY KEY (`work_expId`),
  KEY `fk_Work_Experience_ENUM_Emp_Status1_idx` (`employment_status`),
  KEY `fk_Work_Experience_Person1_idx` (`personId`),
  KEY `fk_Work_Experience_Organization1_idx` (`employerId`),
  CONSTRAINT `fk_Work_Experience_ENUM_Emp_Status1` FOREIGN KEY (`employment_status`) REFERENCES `ENUM_Emp_Status` (`employment_status`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Work_Experience_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Work_Experience_Organization1` FOREIGN KEY (`employerId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Designation` (
  `designationId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `position_templateId` BIGINT UNSIGNED NULL COMMENT 'Define this column if designation is related to an existing position; may be as OIC or on an acting capacity',
  `oic` TINYINT UNSIGNED NULL DEFAULT 0 COMMENT 'Designation as an OIC',
  `acting` TINYINT UNSIGNED NULL DEFAULT 0 COMMENT 'Designation on an acting capacity',
  `parenthetical` TINYINT UNSIGNED NULL DEFAULT 0,
  `concurrent` TINYINT UNSIGNED NULL DEFAULT 0 COMMENT 'Concurrent or full-time designation',
  PRIMARY KEY (`designationId`),
  KEY `fk_Designation_Position1_idx` (`position_templateId`),
  CONSTRAINT `fk_Designation_Position1` FOREIGN KEY (`position_templateId`) REFERENCES `Position` (`positionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Job_Description` (
  `job_descriptionId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `positionId` BIGINT UNSIGNED NOT NULL,
  `dutyId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`job_descriptionId`),
  KEY `fk_Job_Description_Position1_idx` (`positionId`),
  KEY `fk_Job_Description_Duty1_idx` (`dutyId`),
  CONSTRAINT `fk_Job_Description_Position1` FOREIGN KEY (`positionId`) REFERENCES `Position` (`positionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Job_Description_Duty1` FOREIGN KEY (`dutyId`) REFERENCES `Duty` (`dutyId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `OAuth_Account` (
  `oauthId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` BIGINT UNSIGNED NOT NULL,
  `provider` TINYINT UNSIGNED NOT NULL,
  `subject` VARCHAR(255) NOT NULL,
  `deped_email` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`oauthId`),
  UNIQUE KEY `uq_OAuth_Account_provider_subject` (`provider`, `subject`),
  UNIQUE KEY `uq_OAuth_Account_provider_email` (`provider`, `deped_email`),
  KEY `fk_OAuth_Account_User1_idx` (`userId`),
  KEY `fk_OAuth_Account_ENUM_OAuth_Provider1_idx` (`provider`),
  CONSTRAINT `fk_OAuth_Account_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_OAuth_Account_ENUM_OAuth_Provider1` FOREIGN KEY (`provider`) REFERENCES `ENUM_OAuth_Provider` (`provider`) ON DELETE RESTRICT ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `PM_Development_Need` (
  `development_needId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `performance_objectiveId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`development_needId`),
  KEY `fk_PM_Development_Need_Performance_Objective1_idx` (`performance_objectiveId`),
  CONSTRAINT `fk_PM_Development_Need_Performance_Objective1` FOREIGN KEY (`performance_objectiveId`) REFERENCES `Performance_Objective` (`performance_objectiveId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Performance_Indicator` (
  `performance_indicatorId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `performance_objectiveId` BIGINT NOT NULL,
  `pm_indicator_type` TINYINT UNSIGNED NOT NULL COMMENT 'The absence of indicators for an indicator type shall mean a blank for that indicator type.',
  `indicator` VARCHAR(1000) NOT NULL COMMENT 'A clear statement of conditions that need to be met for this indicator.',
  `assigned_score` TINYINT UNSIGNED NULL COMMENT 'An assigned score from 1 to 5.',
  `achieved` TINYINT UNSIGNED NULL DEFAULT 0 COMMENT 'Mark as TRUE if achieved. Only one indicator of an indicator type (the highest achieved indicator) may be marked as achieved for scoring purposes.',
  PRIMARY KEY (`performance_indicatorId`),
  KEY `fk_PM_Indicator_ENUM_PM_Indicator_Type1_idx` (`pm_indicator_type`),
  KEY `fk_PM_Indicator_PM_Objective1_idx` (`performance_objectiveId`),
  CONSTRAINT `fk_PM_Indicator_ENUM_PM_Indicator_Type1` FOREIGN KEY (`pm_indicator_type`) REFERENCES `ENUM_PM_Indicator_Type` (`pm_indicator_type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PM_Indicator_PM_Objective1` FOREIGN KEY (`performance_objectiveId`) REFERENCES `Performance_Objective` (`performance_objectiveId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Plantilla_Item` (
  `plantilla_item_number` VARCHAR(50) NOT NULL,
  `position_templateId` BIGINT UNSIGNED NOT NULL,
  `parenthetical_templateId` BIGINT UNSIGNED NULL,
  `orgId` BIGINT UNSIGNED NOT NULL,
  `org_subunitId` BIGINT UNSIGNED NOT NULL COMMENT '(Sub)unit allocated with the item; Same value as org_unitId for items directly assigned under the Plantilla unit; Equivalent to Workstation/Place of Work of ',
  `assigned_unitId` BIGINT UNSIGNED NULL COMMENT 'For items that are borrowed by other units (via reassignment, detail, designation, etc.)',
  `authorized_salary_step` TINYINT UNSIGNED NULL COMMENT 'Use for computing the DBM authorized annual salary for PSIPOP',
  `item_status` TINYINT UNSIGNED NULL,
  `cti` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `dbm_pos_area_code` VARCHAR(10) NULL,
  `dbm_pos_area_type` VARCHAR(10) NULL,
  `dbm_pos_level` VARCHAR(10) NULL,
  PRIMARY KEY (`plantilla_item_number`),
  KEY `fk_Plantilla_Item_Position1_idx` (`position_templateId`),
  KEY `fk_Plantilla_Item_ENUM_Item_Status1_idx` (`item_status`),
  KEY `fk_Plantilla_Item_Position2_idx` (`parenthetical_templateId`),
  KEY `fk_Plantilla_Item_Organization1_idx` (`orgId`),
  KEY `fk_Plantilla_Item_Organization2_idx` (`org_subunitId`),
  KEY `fk_Plantilla_Item_Organization3_idx` (`assigned_unitId`),
  CONSTRAINT `fk_Plantilla_Item_Position1` FOREIGN KEY (`position_templateId`) REFERENCES `Position` (`positionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plantilla_Item_ENUM_Item_Status1` FOREIGN KEY (`item_status`) REFERENCES `ENUM_Item_Status` (`item_status`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plantilla_Item_Position2` FOREIGN KEY (`parenthetical_templateId`) REFERENCES `Position` (`positionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plantilla_Item_Organization1` FOREIGN KEY (`orgId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plantilla_Item_Organization2` FOREIGN KEY (`org_subunitId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plantilla_Item_Organization3` FOREIGN KEY (`assigned_unitId`) REFERENCES `Organization` (`orgId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Position_QS` (
  `qsId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `positionId` BIGINT UNSIGNED NOT NULL,
  `qs_type` TINYINT UNSIGNED NOT NULL,
  `qs_level` FLOAT UNSIGNED NOT NULL COMMENT 'May refer to:
* Education level attained (incremental)
* Hours of relevant training
* Years of relevant experience
* Eligibility id',
  `qs_description` LONGTEXT NOT NULL COMMENT 'Required for uncommon/detailed QS description and for competencies',
  `alternative_QS` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Alternative QS shall be marked as TRUE when a QS has different QS levels (e.g., different educ level, different training hours requirement, different years of experience, etc.); QS shall be identified in the score table for scoring purposes; Will be ignored if preferred_QS is marked as TRUE',
  `preferred_QS` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Preferred QS shall not be used for scoring but shall only be used as reference for choosing the optimal candidates after comparative assessments are scored accordingly.',
  PRIMARY KEY (`qsId`),
  KEY `fk_Position_QS_ENUM_QS_Type1_idx` (`qs_type`),
  KEY `fk_Position_QS_Position1_idx` (`positionId`),
  CONSTRAINT `fk_Position_QS_ENUM_QS_Type1` FOREIGN KEY (`qs_type`) REFERENCES `ENUM_QS_Type` (`qs_type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Position_QS_Position1` FOREIGN KEY (`positionId`) REFERENCES `Position` (`positionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Qualification Standards for Positions';

CREATE TABLE `User_Login` (
  `loginId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` BIGINT UNSIGNED NOT NULL,
  `email` VARCHAR(250) NOT NULL,
  `is_primary` BOOLEAN NOT NULL DEFAULT 0,
  `is_verified` BOOLEAN NOT NULL DEFAULT 0,
  `provider` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`loginId`),
  UNIQUE KEY `uq_User_Login_email` (`email`),
  KEY `fk_User_Login_User1_idx` (`userId`),
  KEY `fk_User_Login_ENUM_OAuth_Provider1_idx` (`provider`),
  CONSTRAINT `fk_User_Login_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_Login_ENUM_OAuth_Provider1` FOREIGN KEY (`provider`) REFERENCES `ENUM_OAuth_Provider` (`provider`) ON DELETE RESTRICT ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `User_Right` (
  `userId` BIGINT UNSIGNED NOT NULL,
  `rightId` BIGINT UNSIGNED NOT NULL,
  `granted` BOOLEAN NOT NULL DEFAULT 1,
  PRIMARY KEY (`userId`, `rightId`),
  KEY `fk_User_Right_User1_idx` (`userId`),
  KEY `fk_User_Right_Right1_idx` (`rightId`),
  CONSTRAINT `fk_User_Right_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_Right_Right1` FOREIGN KEY (`rightId`) REFERENCES `Right` (`rightId`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `User_Role` (
  `userId` BIGINT UNSIGNED NOT NULL,
  `roleId` BIGINT UNSIGNED NOT NULL,
  `granted_by` BIGINT UNSIGNED NULL,
  `granted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userId`, `roleId`),
  KEY `fk_User_Role_User1_idx` (`userId`),
  KEY `fk_User_Role_Role1_idx` (`roleId`),
  KEY `fk_User_Role_User2_idx` (`granted_by`),
  CONSTRAINT `fk_User_Role_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_Role_Role1` FOREIGN KEY (`roleId`) REFERENCES `Role` (`roleId`) ON DELETE RESTRICT ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_Role_User2` FOREIGN KEY (`granted_by`) REFERENCES `User` (`userId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Verification_Token` (
  `tokenId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` BIGINT UNSIGNED NOT NULL,
  `loginId` BIGINT UNSIGNED NULL,
  `token_hash` CHAR(64) NOT NULL,
  `purpose` ENUM('signup','verify_alt','reset','link') NOT NULL,
  `expires_at` DATETIME NOT NULL,
  `used_at` DATETIME NULL,
  PRIMARY KEY (`tokenId`),
  KEY `idx_Verification_Token_hash` (`token_hash`),
  KEY `fk_Verification_Token_User1_idx` (`userId`),
  CONSTRAINT `fk_Verification_Token_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Incumbency` (
  `incumbencyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `plantilla_item_number` VARCHAR(50) NULL,
  `positionId` BIGINT UNSIGNED NULL,
  `designationId` BIGINT UNSIGNED NULL COMMENT 'Ignored when either plantilla item number or positionId is specified',
  `empno` VARCHAR(50) NOT NULL,
  `employment_status` TINYINT UNSIGNED NULL,
  `salary_grade` TINYINT UNSIGNED NULL,
  `salary_step` TINYINT UNSIGNED NULL,
  `salary` FLOAT UNSIGNED NULL,
  `hr_action` TINYINT UNSIGNED NULL,
  `start_date` DATE NULL COMMENT 'Tentative if left blank',
  `end_date` DATE NULL COMMENT 'Blank for current incumbents',
  `mode_of_separation` TINYINT UNSIGNED NULL COMMENT 'Include transfer in the modes of separation; NULL or 0 means still in active service',
  `remarks` LONGTEXT NULL COMMENT 'Keep remarks short for service record-related HR actions',
  PRIMARY KEY (`incumbencyId`),
  KEY `fk_Incumbency_Plantilla_Item1_idx` (`plantilla_item_number`),
  KEY `fk_Incumbency_Position1_idx` (`positionId`),
  KEY `fk_Incumbency_Employee1_idx` (`empno`),
  KEY `fk_Incumbency_Designation1_idx` (`designationId`),
  KEY `fk_Incumbency_ENUM_Emp_Status1_idx` (`employment_status`),
  KEY `fk_Incumbency_ENUM_HR_Action1_idx` (`hr_action`),
  KEY `fk_Incumbency_ENUM_HR_Action2_idx` (`mode_of_separation`),
  CONSTRAINT `fk_Incumbency_Plantilla_Item1` FOREIGN KEY (`plantilla_item_number`) REFERENCES `Plantilla_Item` (`plantilla_item_number`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incumbency_Position1` FOREIGN KEY (`positionId`) REFERENCES `Position` (`positionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incumbency_Employee1` FOREIGN KEY (`empno`) REFERENCES `Employee` (`empno`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incumbency_Designation1` FOREIGN KEY (`designationId`) REFERENCES `Designation` (`designationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incumbency_ENUM_Emp_Status1` FOREIGN KEY (`employment_status`) REFERENCES `ENUM_Emp_Status` (`employment_status`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incumbency_ENUM_HR_Action1` FOREIGN KEY (`hr_action`) REFERENCES `ENUM_HR_Action` (`hr_action`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incumbency_ENUM_HR_Action2` FOREIGN KEY (`mode_of_separation`) REFERENCES `ENUM_HR_Action` (`hr_action`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='This should cover all HR actions related to incumbency.';

CREATE TABLE `PM_Action_Plan` (
  `action_planId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `development_needId` BIGINT UNSIGNED NOT NULL,
  `learning_objective` VARCHAR(1000) NOT NULL,
  `intervention` VARCHAR(1000) NOT NULL,
  `timeline` VARCHAR(100) NOT NULL,
  `resources_needed` VARCHAR(1000) NOT NULL,
  PRIMARY KEY (`action_planId`),
  KEY `fk_PM_Action_Plan_PM_Development_Need1_idx` (`development_needId`),
  CONSTRAINT `fk_PM_Action_Plan_PM_Development_Need1` FOREIGN KEY (`development_needId`) REFERENCES `PM_Development_Need` (`development_needId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Term_of_Reference` (
  `torId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `designationId` BIGINT UNSIGNED NOT NULL,
  `dutyId` BIGINT UNSIGNED NOT NULL COMMENT '6',
  PRIMARY KEY (`torId`),
  KEY `fk_Term_of_Reference_Designation1_idx` (`designationId`),
  KEY `fk_Term_of_Reference_Duty1_idx` (`dutyId`),
  CONSTRAINT `fk_Term_of_Reference_Designation1` FOREIGN KEY (`designationId`) REFERENCES `Designation` (`designationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Term_of_Reference_Duty1` FOREIGN KEY (`dutyId`) REFERENCES `Duty` (`dutyId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Terms of reference';

CREATE TABLE `Unlink_Request` (
  `requestId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` BIGINT UNSIGNED NOT NULL,
  `oauthId` BIGINT UNSIGNED NOT NULL,
  `status` ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `requested_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `decided_by` BIGINT UNSIGNED NULL,
  `decided_at` DATETIME NULL,
  PRIMARY KEY (`requestId`),
  KEY `fk_Unlink_Request_User1_idx` (`userId`),
  KEY `fk_Unlink_Request_OAuth_Account1_idx` (`oauthId`),
  CONSTRAINT `fk_Unlink_Request_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_Unlink_Request_OAuth_Account1` FOREIGN KEY (`oauthId`) REFERENCES `OAuth_Account` (`oauthId`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Vacancy` (
  `vacancyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `plantilla_item_number` VARCHAR(50) NULL,
  `positionId` BIGINT UNSIGNED NULL,
  `vacancy_date` DATE NOT NULL,
  `anticipated` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Mark as TRUE if item is marked as vacant before the vacancy date.',
  `timestamp` TIMESTAMP_F NOT NULL,
  `application_code_prefix` VARCHAR(25) NOT NULL,
  `rsp_cycleId` BIGINT UNSIGNED NULL,
  `criteriaId` BIGINT UNSIGNED NULL COMMENT 'Top-level criterionId that represents the set of criteria to be used.',
  PRIMARY KEY (`vacancyId`),
  KEY `fk_Vacancy_Plantilla_Item1_idx` (`plantilla_item_number`),
  KEY `fk_Vacancy_Position1_idx` (`positionId`),
  KEY `fk_Vacancy_RSP_Cycle1_idx` (`rsp_cycleId`),
  KEY `fk_Vacancy_RSP_Criterion1_idx` (`criteriaId`),
  CONSTRAINT `fk_Vacancy_Plantilla_Item1` FOREIGN KEY (`plantilla_item_number`) REFERENCES `Plantilla_Item` (`plantilla_item_number`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vacancy_Position1` FOREIGN KEY (`positionId`) REFERENCES `Position` (`positionId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vacancy_RSP_Cycle1` FOREIGN KEY (`rsp_cycleId`) REFERENCES `RSP_Cycle` (`rsp_cycleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vacancy_RSP_Criterion1` FOREIGN KEY (`criteriaId`) REFERENCES `Criterion` (`criterionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `CAR` (
  `carId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `vacancyId` BIGINT UNSIGNED NOT NULL,
  `version` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'For multiple versions of the CAR. Only the latest version shall be used/issued. It is recommended to avoid having multiple versions of the CAR to maintain trust in the integrity of the RSP process',
  `finalized` DATETIME NULL COMMENT 'Finalization may involve the complete digital signing of the CAR. Cannot be unset in IHRMIS once this has been set.',
  PRIMARY KEY (`carId`),
  KEY `fk_IER_Vacancy1_idx` (`vacancyId`),
  CONSTRAINT `fk_IER_Vacancy10` FOREIGN KEY (`vacancyId`) REFERENCES `Vacancy` (`vacancyId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `IER` (
  `ierId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `vacancyId` BIGINT UNSIGNED NOT NULL,
  `version` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'For multiple versions of the IER. Only the latest version shall be used/issued. It is recommended to avoid having multiple versions of the IER to maintain trust in the integrity of the RSP process',
  `finalized` DATETIME NULL COMMENT 'Finalization may involve the digital signing of the IER. Cannot be unset in IHRMIS once this has been set.',
  PRIMARY KEY (`ierId`),
  KEY `fk_IER_Vacancy1_idx` (`vacancyId`),
  CONSTRAINT `fk_IER_Vacancy1` FOREIGN KEY (`vacancyId`) REFERENCES `Vacancy` (`vacancyId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Item_Publication` (
  `publicationId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `vacancyId` BIGINT UNSIGNED NOT NULL,
  `publication_date` DATE NOT NULL COMMENT 'Include publication date in case timestamp date and effective date of the publication do not coincide',
  `republication` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `timestamp` TIMESTAMP_F NOT NULL,
  PRIMARY KEY (`publicationId`),
  KEY `fk_Item_Publication_Vacancy1_idx` (`vacancyId`),
  CONSTRAINT `fk_Item_Publication_Vacancy1` FOREIGN KEY (`vacancyId`) REFERENCES `Vacancy` (`vacancyId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Job_Application` (
  `application_code` VARCHAR(50) NOT NULL,
  `personId` BIGINT UNSIGNED NOT NULL,
  `vacancyId` BIGINT UNSIGNED NOT NULL,
  `checked` DATETIME NULL COMMENT 'Only filled if applicant submits application documents for checking before having the checklist notarized or signed by an official authorized to administer oath.',
  `submitted` DATETIME NULL,
  `include_in_ier` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `include_in_car` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Included only if applicant is qualified and has attended all necessary assessments.',
  PRIMARY KEY (`application_code`),
  KEY `fk_Job_Application_Vacancy1_idx` (`vacancyId`),
  KEY `fk_Job_Application_Person1_idx` (`personId`),
  CONSTRAINT `fk_Job_Application_Vacancy1` FOREIGN KEY (`vacancyId`) REFERENCES `Vacancy` (`vacancyId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Job_Application_Person1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Applicant_Evaluation` (
  `evaluationId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `application_code` VARCHAR(50) NOT NULL,
  `initial` TINYINT NOT NULL DEFAULT 1,
  `ierId` BIGINT UNSIGNED NULL COMMENT 'ierId and carId cannot both be set',
  `carId` BIGINT UNSIGNED NULL COMMENT 'ierId and carId cannot both be set',
  PRIMARY KEY (`evaluationId`),
  KEY `fk_Application_Evaluation_Job_Application1_idx` (`application_code`),
  KEY `fk_Application_Evaluation_IER1_idx` (`ierId`),
  KEY `fk_Applicant_Evaluation_CAR1_idx` (`carId`),
  CONSTRAINT `fk_Application_Evaluation_Job_Application1` FOREIGN KEY (`application_code`) REFERENCES `Job_Application` (`application_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Application_Evaluation_IER1` FOREIGN KEY (`ierId`) REFERENCES `IER` (`ierId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Applicant_Evaluation_CAR1` FOREIGN KEY (`carId`) REFERENCES `CAR` (`carId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='An applicant evaluation will be generated starting initial evaluation. For successive versions of IER and CAR, applicant evaluations shall also be duplicated before modification.';

CREATE TABLE `Applicant_Evaluation_History` (
  `app_eval_histId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `evaluationId` BIGINT UNSIGNED NOT NULL,
  `memberId` BIGINT UNSIGNED NOT NULL COMMENT 'RSP team member who viewed or modified the record',
  `update` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'FALSE: Viewed evaluation record
TRUE: Edited/saved evaluation record',
  `timestamp` TIMESTAMP_F NOT NULL,
  PRIMARY KEY (`app_eval_histId`),
  KEY `fk_Application_Evaluation_History_Application_Evaluation1_idx` (`evaluationId`),
  KEY `fk_Applicant_Evaluation_History_Team_Member1_idx` (`memberId`),
  CONSTRAINT `fk_Application_Evaluation_History_Application_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Applicant_Evaluation_History_Team_Member1` FOREIGN KEY (`memberId`) REFERENCES `?` (`memberId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Applicant_Score` (
  `scoreId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `evaluationId` BIGINT UNSIGNED NOT NULL,
  `criterionId` BIGINT UNSIGNED NOT NULL,
  `raw_score` FLOAT NULL,
  `max` FLOAT NULL COMMENT 'Ignores max in criterion of this is defined',
  `final_score` FLOAT NULL COMMENT 'Required for finalized CAR',
  PRIMARY KEY (`scoreId`),
  KEY `fk_Applicant_Score_Application_Evaluation1_idx` (`evaluationId`),
  KEY `fk_Applicant_Score_RSP_Criterion1_idx` (`criterionId`),
  CONSTRAINT `fk_Applicant_Score_Application_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Applicant_Score_RSP_Criterion1` FOREIGN KEY (`criterionId`) REFERENCES `Criterion` (`criterionId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `RSP_Classroom_Observation` (
  `rsp_coId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `evaluationId` BIGINT NOT NULL,
  `classroom_observationId` BIGINT NOT NULL,
  PRIMARY KEY (`rsp_coId`),
  KEY `fk_PM_Classroom_Observation_Classroom_Observation1_idx` (`classroom_observationId`),
  KEY `fk_RSP_Classroom_Observation_Applicant_Evaluation1_idx` (`evaluationId`),
  CONSTRAINT `fk_PM_Classroom_Observation_Classroom_Observation10` FOREIGN KEY (`classroom_observationId`) REFERENCES `?` (`classroom_observationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RSP_Classroom_Observation_Applicant_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Relevant_Competency` (
  `relevant_educationId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `application_code` VARCHAR(50) NOT NULL,
  `competency_description` LONGTEXT NOT NULL COMMENT 'Describe competency of applicant based on presented documents',
  `qsId` BIGINT UNSIGNED NOT NULL,
  `evaluationId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`relevant_educationId`),
  KEY `fk_Relevant_Competency_Job_Application1_idx` (`application_code`),
  KEY `fk_Relevant_Competency_Position_QS1_idx` (`qsId`),
  KEY `fk_Relevant_Competency_Application_Evaluation1_idx` (`evaluationId`),
  CONSTRAINT `fk_Relevant_Competency_Job_Application1` FOREIGN KEY (`application_code`) REFERENCES `Job_Application` (`application_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Competency_Position_QS1` FOREIGN KEY (`qsId`) REFERENCES `Position_QS` (`qsId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Competency_Application_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Relevant_Education` (
  `relevant_educationId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `application_code` VARCHAR(50) NOT NULL,
  `educId` BIGINT UNSIGNED NOT NULL,
  `qsId` BIGINT UNSIGNED NOT NULL,
  `evaluationId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`relevant_educationId`),
  KEY `fk_Relevant_Education_Job_Application1_idx` (`application_code`),
  KEY `fk_Relevant_Education_Education1_idx` (`educId`),
  KEY `fk_Relevant_Education_Position_QS1_idx` (`qsId`),
  KEY `fk_Relevant_Education_Application_Evaluation1_idx` (`evaluationId`),
  CONSTRAINT `fk_Relevant_Education_Job_Application1` FOREIGN KEY (`application_code`) REFERENCES `Job_Application` (`application_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Education_Education1` FOREIGN KEY (`educId`) REFERENCES `Education` (`educId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Education_Position_QS1` FOREIGN KEY (`qsId`) REFERENCES `Position_QS` (`qsId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Education_Application_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Relevant_Eligibility` (
  `relevant_eligibilityId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `application_code` VARCHAR(50) NOT NULL,
  `eligibilityId` BIGINT UNSIGNED NOT NULL,
  `qsId` BIGINT UNSIGNED NOT NULL,
  `evaluationId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`relevant_eligibilityId`),
  KEY `fk_Relevant_Eligibility_Job_Application1_idx` (`application_code`),
  KEY `fk_Relevant_Eligibility_Eligibility1_idx` (`eligibilityId`),
  KEY `fk_Relevant_Eligibility_Position_QS1_idx` (`qsId`),
  KEY `fk_Relevant_Eligibility_Application_Evaluation1_idx` (`evaluationId`),
  CONSTRAINT `fk_Relevant_Eligibility_Job_Application1` FOREIGN KEY (`application_code`) REFERENCES `Job_Application` (`application_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Eligibility_Eligibility1` FOREIGN KEY (`eligibilityId`) REFERENCES `Eligibility` (`eligibilityId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Eligibility_Position_QS1` FOREIGN KEY (`qsId`) REFERENCES `Position_QS` (`qsId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Eligibility_Application_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Relevant_Training` (
  `relevant_trainingId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `application_code` VARCHAR(50) NOT NULL,
  `trainingId` BIGINT UNSIGNED NOT NULL,
  `qsId` BIGINT UNSIGNED NOT NULL,
  `evaluationId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`relevant_trainingId`),
  KEY `fk_Relevant_Training_Job_Application1_idx` (`application_code`),
  KEY `fk_Relevant_Training_Training1_idx` (`trainingId`),
  KEY `fk_Relevant_Training_Position_QS1_idx` (`qsId`),
  KEY `fk_Relevant_Training_Application_Evaluation1_idx` (`evaluationId`),
  CONSTRAINT `fk_Relevant_Training_Job_Application1` FOREIGN KEY (`application_code`) REFERENCES `Job_Application` (`application_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Training_Training1` FOREIGN KEY (`trainingId`) REFERENCES `Training` (`trainingId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Training_Position_QS1` FOREIGN KEY (`qsId`) REFERENCES `Position_QS` (`qsId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Training_Application_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `Relevant_Work` (
  `relevant_workId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `application_code` VARCHAR(50) NOT NULL,
  `work_expId` BIGINT UNSIGNED NOT NULL,
  `qsId` BIGINT UNSIGNED NOT NULL,
  `evaluationId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`relevant_workId`),
  KEY `fk_Relevant_Work_Job_Application1_idx` (`application_code`),
  KEY `fk_Relevant_Work_Work_Experience1_idx` (`work_expId`),
  KEY `fk_Relevant_Work_Position_QS1_idx` (`qsId`),
  KEY `fk_Relevant_Work_Application_Evaluation1_idx` (`evaluationId`),
  CONSTRAINT `fk_Relevant_Work_Job_Application1` FOREIGN KEY (`application_code`) REFERENCES `Job_Application` (`application_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Work_Work_Experience1` FOREIGN KEY (`work_expId`) REFERENCES `Work_Experience` (`work_expId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Work_Position_QS1` FOREIGN KEY (`qsId`) REFERENCES `Position_QS` (`qsId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relevant_Work_Application_Evaluation1` FOREIGN KEY (`evaluationId`) REFERENCES `Applicant_Evaluation` (`evaluationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ---- seed rows (Workbench Inserts tab; model-canonical) ----
-- Idempotent (ON DUPLICATE KEY UPDATE) so schema.sql and the
-- deploy seeder converge regardless of run order. Role_Right
-- grants are intentionally NOT here: their ids only exist at
-- deploy time and are resolved by the seeder.
INSERT INTO `ENUM_OAuth_Provider` (`description`, `provider`, `name`) VALUES (NULL, 0, 'Not specified') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_OAuth_Provider` (`description`, `provider`, `name`) VALUES (NULL, 1, 'Local') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_OAuth_Provider` (`description`, `provider`, `name`) VALUES (NULL, 2, 'Google') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_OAuth_Provider` (`description`, `provider`, `name`) VALUES (NULL, 3, 'Microsoft 365') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_User_Status` (`description`, `status`, `name`) VALUES (NULL, 0, 'Not specified') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_User_Status` (`description`, `status`, `name`) VALUES (NULL, 1, 'Active') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_User_Status` (`description`, `status`, `name`) VALUES (NULL, 2, 'Inactive') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_User_Status` (`description`, `status`, `name`) VALUES (NULL, 3, 'Separated') ON DUPLICATE KEY UPDATE `description`=VALUES(`description`), `name`=VALUES(`name`);
INSERT INTO `ENUM_User_Type` (`name`, `description`, `user_type`) VALUES ('Not specified', NULL, 0) ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`);
INSERT INTO `ENUM_User_Type` (`name`, `description`, `user_type`) VALUES ('External', NULL, 1) ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`);
INSERT INTO `ENUM_User_Type` (`name`, `description`, `user_type`) VALUES ('Employee', NULL, 2) ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`);

SET FOREIGN_KEY_CHECKS=1;
