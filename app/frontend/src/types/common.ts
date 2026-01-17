// Frontend-only types (not generated from OpenAPI)

export interface Page<T> {
  content: T[];
  number: number;
  size: number;
  totalElements: number;
  totalPages: number;
}

export interface ApiError {
  status: number;
  message: string;
}

export interface SemesterContext {
  openingYear: number;
  semester: string;
}

export interface CourseSearchParams {
  universityId?: number;
  openingYear?: number;
  semester?: string;
  query?: string;
  professor?: string;
  departmentName?: string;
  campus?: string;
  targetGrade?: number;
  credits?: number;
  page?: number;
  size?: number;
}
