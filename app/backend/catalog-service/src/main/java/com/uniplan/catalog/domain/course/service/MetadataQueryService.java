package com.uniplan.catalog.domain.course.service;

import com.uniplan.catalog.domain.course.dto.MetadataResponse;
import com.uniplan.catalog.domain.course.entity.College;
import com.uniplan.catalog.domain.course.entity.CourseType;
import com.uniplan.catalog.domain.course.entity.Department;
import com.uniplan.catalog.domain.course.repository.CollegeRepository;
import com.uniplan.catalog.domain.course.repository.CourseTypeRepository;
import com.uniplan.catalog.domain.course.repository.DepartmentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class MetadataQueryService {

    private final CollegeRepository collegeRepository;
    private final DepartmentRepository departmentRepository;
    private final CourseTypeRepository courseTypeRepository;

    public MetadataResponse.CourseTypesResponse getAllCourseTypes() {
        List<CourseType> courseTypes = courseTypeRepository.findAll();

        List<MetadataResponse.CourseTypeDto> dtos = courseTypes.stream()
            .map(ct -> MetadataResponse.CourseTypeDto.builder()
                .id(ct.getId())
                .code(ct.getCode())
                .nameKr(ct.getNameKr())
                .nameEn(ct.getNameEn())
                .build())
            .collect(Collectors.toList());

        return MetadataResponse.CourseTypesResponse.builder()
            .courseTypes(dtos)
            .build();
    }

    public MetadataResponse.DepartmentsResponse getAllDepartments() {
        List<Department> departments = departmentRepository.findAll();

        List<MetadataResponse.DepartmentDto> dtos = departments.stream()
            .map(dept -> MetadataResponse.DepartmentDto.builder()
                .id(dept.getId())
                .code(dept.getCode())
                .name(dept.getName())
                .nameEn(dept.getNameEn())
                .level(dept.getLevel())
                .college(MetadataResponse.CollegeDto.builder()
                    .id(dept.getCollege().getId())
                    .code(dept.getCollege().getCode())
                    .name(dept.getCollege().getName())
                    .nameEn(dept.getCollege().getNameEn())
                    .build())
                .build())
            .collect(Collectors.toList());

        return MetadataResponse.DepartmentsResponse.builder()
            .departments(dtos)
            .build();
    }

    public MetadataResponse.CollegesResponse getAllColleges() {
        List<College> colleges = collegeRepository.findAll();

        List<MetadataResponse.CollegeDto> dtos = colleges.stream()
            .map(college -> MetadataResponse.CollegeDto.builder()
                .id(college.getId())
                .code(college.getCode())
                .name(college.getName())
                .nameEn(college.getNameEn())
                .build())
            .collect(Collectors.toList());

        return MetadataResponse.CollegesResponse.builder()
            .colleges(dtos)
            .build();
    }
}