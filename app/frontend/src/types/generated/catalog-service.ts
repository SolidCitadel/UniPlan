// Auto-generated from OpenAPI - DO NOT EDIT MANUALLY
// Run `npm run types:generate` to regenerate this file
//
// This is a placeholder file. The actual types will be generated
// when you run `npm run types:generate` with the backend running.

export interface components {
  schemas: {
    ClassTimeResponse: {
      day: string;
      startTime: string;
      endTime: string;
    };
    CourseResponse: {
      id: number;
      openingYear: number;
      semester: string;
      targetGrade?: number;
      courseCode: string;
      section?: string;
      courseName: string;
      professor?: string;
      credits: number;
      classroom?: string;
      campus: string;
      notes?: string;
      departmentCode?: string;
      departmentName?: string;
      collegeCode?: string;
      collegeName?: string;
      courseTypeCode?: string;
      courseTypeName?: string;
      classTimes: components['schemas']['ClassTimeResponse'][];
    };
  };
}

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface paths {}
// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface operations {}
