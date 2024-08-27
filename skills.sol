// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Institute {
    // Struct to represent a Teacher
    struct Teacher {
        string name;
        string[] skills; // Array to store the skills of the teacher
    }

    // Struct to represent a Student
    struct Student {
        string name;
        string[] requiredSkills; // Array to store the skills required by the student
    }

    // Mappings to store teachers and students by their Ethereum addresses
    mapping(address => Teacher) public teachers;
    mapping(address => Student) public students;

    // Arrays to keep track of all teacher and student addresses
    address[] public teacherAddresses;
    address[] public studentAddresses;

    // Function to add a new teacher
    function addTeacher(
        address _teacherAddress,
        string memory _name,
        string[] memory _skills
    ) public {
        Teacher storage teacher = teachers[_teacherAddress];
        teacher.name = _name;
        teacher.skills = _skills;
        teacherAddresses.push(_teacherAddress);
    }

    // Function to add a new student
    function addStudent(
        address _studentAddress,
        string memory _name,
        string[] memory _requiredSkills
    ) public {
        Student storage student = students[_studentAddress];
        student.name = _name;
        student.requiredSkills = _requiredSkills;
        studentAddresses.push(_studentAddress);
    }

    // Function to find matching teachers for a given student
    function findMatchingTeachers(address _studentAddress) public view returns (address[] memory) {
        Student storage student = students[_studentAddress];
        uint matchCount = 0;

        // Count how many matches we have to size the array
        for (uint i = 0; i < teacherAddresses.length; i++) {
            if (hasMatchingSkills(teachers[teacherAddresses[i]].skills, student.requiredSkills)) {
                matchCount++;
            }
        }

        // Create an array to store matching teacher addresses
        address[] memory matchingTeachers = new address[](matchCount);
        uint index = 0;

        // Populate the array with matching teachers
        for (uint i = 0; i < teacherAddresses.length; i++) {
            if (hasMatchingSkills(teachers[teacherAddresses[i]].skills, student.requiredSkills)) {
                matchingTeachers[index] = teacherAddresses[i];
                index++;
            }
        }

        return matchingTeachers;
    }

    // Helper function to check if a teacher has matching skills
    function hasMatchingSkills(string[] memory teacherSkills, string[] memory studentSkills) internal pure returns (bool) {
        for (uint i = 0; i < studentSkills.length; i++) {
            for (uint j = 0; j < teacherSkills.length; j++) {
                if (keccak256(abi.encodePacked(studentSkills[i])) == keccak256(abi.encodePacked(teacherSkills[j]))) {
                    return true;
                }
            }
        }
        return false;
    }

    // Function to get the total number of teachers
    function getTeacherCount() public view returns (uint) {
        return teacherAddresses.length;
    }

    // Function to get the total number of students
    function getStudentCount() public view returns (uint) {
        return studentAddresses.length;
    }
}
