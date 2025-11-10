-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 08, 2025 at 12:13 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `attendance_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic_calendar`
--

CREATE TABLE `academic_calendar` (
  `id` int(11) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `semester` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academic_calendar`
--

INSERT INTO `academic_calendar` (`id`, `academic_year`, `semester`, `start_date`, `end_date`) VALUES
(1, '2025-2026', 3, '2025-07-01', '2025-12-22');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `attendance_date` date NOT NULL,
  `status` enum('Present','Absent') NOT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `lecture_number` int(11) DEFAULT NULL,
  `semester` int(11) DEFAULT NULL,
  `academic_year` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `student_id`, `attendance_date`, `status`, `subject_id`, `teacher_id`, `lecture_number`, `semester`, `academic_year`) VALUES
(23, 1, '2025-11-08', 'Absent', NULL, NULL, 1, 3, '2024-2025'),
(24, 2, '2025-11-08', 'Absent', NULL, NULL, 1, 3, '2024-2025'),
(25, 1, '2025-11-03', 'Present', 1, 1, 1, 3, '2024-2025'),
(26, 2, '2025-11-03', 'Absent', 1, 1, 1, 3, '2024-2025'),
(27, 1, '2025-11-04', 'Absent', 1, 1, 2, 3, '2024-2025'),
(28, 2, '2025-11-04', 'Present', 1, 1, 2, 3, '2024-2025'),
(29, 1, '2025-11-05', 'Absent', 1, 1, 3, 3, '2024-2025'),
(30, 2, '2025-11-05', 'Absent', 1, 1, 3, 3, '2024-2025'),
(31, 1, '2025-11-04', 'Present', 2, 2, 1, 3, '2024-2025'),
(32, 2, '2025-11-04', 'Present', 2, 2, 1, 3, '2024-2025'),
(33, 1, '2025-11-05', 'Absent', 2, 2, 2, 3, '2024-2025'),
(34, 2, '2025-11-05', 'Absent', 2, 2, 2, 3, '2024-2025'),
(35, 1, '2025-11-06', 'Present', 2, 2, 3, 3, '2024-2025'),
(36, 2, '2025-11-06', 'Present', 2, 2, 3, 3, '2024-2025');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `roll_number` varchar(20) NOT NULL,
  `semester` int(11) DEFAULT NULL,
  `academic_year` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `user_id`, `roll_number`, `semester`, `academic_year`) VALUES
(1, 2, 'ROLL001', 3, '2024-2025'),
(2, 3, 'ROLL002', 3, '2024-2025');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `credits` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `credits`) VALUES
(1, 'CS301', 'Data Structures', 4),
(2, 'CS302', 'Advanced Java Technology', 4),
(3, 'CS303', 'Computer Network Fundamentals', 3),
(4, 'MA301', 'Mathematics', 3),
(5, 'CS304', 'Data Management System and Security', 4);

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `teacher_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`id`, `user_id`, `teacher_id`) VALUES
(1, 4, 'T001'),
(2, 5, 'T002'),
(3, 6, 'T003'),
(4, 7, 'T004'),
(5, 8, 'T005');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_subjects`
--

CREATE TABLE `teacher_subjects` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher_subjects`
--

INSERT INTO `teacher_subjects` (`id`, `teacher_id`, `subject_id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `timetable`
--

CREATE TABLE `timetable` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
  `lecture_number` int(11) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `timetable`
--

INSERT INTO `timetable` (`id`, `subject_id`, `teacher_id`, `day_of_week`, `lecture_number`, `start_time`, `end_time`) VALUES
(1, 1, 1, 'Monday', 1, '09:00:00', '10:00:00'),
(2, 3, 3, 'Monday', 2, '10:00:00', '11:00:00'),
(3, 5, 5, 'Monday', 3, '11:15:00', '12:15:00'),
(4, 4, 4, 'Monday', 4, '13:00:00', '14:00:00'),
(5, 2, 2, 'Tuesday', 1, '09:00:00', '10:00:00'),
(6, 1, 1, 'Tuesday', 2, '10:00:00', '11:00:00'),
(7, 3, 3, 'Tuesday', 3, '11:15:00', '12:15:00'),
(8, 5, 5, 'Tuesday', 4, '13:00:00', '14:00:00'),
(9, 4, 4, 'Wednesday', 1, '09:00:00', '10:00:00'),
(10, 2, 2, 'Wednesday', 2, '10:00:00', '11:00:00'),
(11, 1, 1, 'Wednesday', 3, '11:15:00', '12:15:00'),
(12, 3, 3, 'Wednesday', 4, '13:00:00', '14:00:00'),
(13, 5, 5, 'Thursday', 1, '09:00:00', '10:00:00'),
(14, 4, 4, 'Thursday', 2, '10:00:00', '11:00:00'),
(15, 2, 2, 'Thursday', 3, '11:15:00', '12:15:00'),
(16, 1, 1, 'Thursday', 4, '13:00:00', '14:00:00'),
(17, 3, 3, 'Friday', 1, '09:00:00', '10:00:00'),
(18, 5, 5, 'Friday', 2, '10:00:00', '11:00:00'),
(19, 4, 4, 'Friday', 3, '11:15:00', '12:15:00'),
(20, 2, 2, 'Friday', 4, '13:00:00', '14:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` enum('admin','teacher','student') NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `name`) VALUES
(1, 'admin', 'admin123', 'admin', 'Admin User'),
(2, 'Rudra', 'student123', 'student', 'Rudra'),
(3, 'Foram', 'student123', 'student', 'Foram\r\n'),
(4, 'dsmith', 'teacher123', 'teacher', 'Dr. David Smith'),
(5, 'rjones', 'teacher123', 'teacher', 'Prof. Robert Jones'),
(6, 'mwilson', 'teacher123', 'teacher', 'Dr. Maria Wilson'),
(7, 'pandey', 'teacher123', 'teacher', 'Prof. Priya Pandey'),
(8, 'kumar', 'teacher123', 'teacher', 'Dr. Sanjay Kumar'),
(9, 'Dharmik', 'student123', 'student', 'Dharmik'),
(10, 'Tirth', 'student123', 'student', 'Tirth'),
(11, 'Nishit', 'student123', 'student', 'Nishit'),
(12, 'Ram', 'student123', 'student', 'Ram');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_calendar`
--
ALTER TABLE `academic_calendar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roll_number` (`roll_number`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `teacher_id` (`teacher_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `teacher_subjects`
--
ALTER TABLE `teacher_subjects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `timetable`
--
ALTER TABLE `timetable`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_calendar`
--
ALTER TABLE `academic_calendar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `teacher_subjects`
--
ALTER TABLE `teacher_subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `timetable`
--
ALTER TABLE `timetable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`);

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `teacher_subjects`
--
ALTER TABLE `teacher_subjects`
  ADD CONSTRAINT `teacher_subjects_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`),
  ADD CONSTRAINT `teacher_subjects_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`);

--
-- Constraints for table `timetable`
--
ALTER TABLE `timetable`
  ADD CONSTRAINT `timetable_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  ADD CONSTRAINT `timetable_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
