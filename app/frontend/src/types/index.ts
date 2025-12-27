// Common Types
export interface Page<T> {
  content: T[];
  number: number;
  size: number;
  totalElements: number;
  totalPages: number;
}

export interface ClassTime {
  day: string;
  startTime: string;
  endTime: string;
}

// Auth
export interface User {
  id: number;
  email: string;
  name: string;
  role: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  user: User;
}

export interface SignupRequest {
  email: string;
  password: string;
  name: string;
}

// Course
export interface Course {
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
  departmentCode?: string;
  departmentName?: string;
  collegeCode?: string;
  collegeName?: string;
  classTimes: ClassTime[];
}

export interface CourseSearchParams {
  query?: string;
  professor?: string;
  departmentName?: string;
  campus?: string;
  targetGrade?: number;
  credits?: number;
  page?: number;
  size?: number;
}

// Wishlist
export interface WishlistItem {
  id: number;
  courseId: number;
  courseName: string;
  professor: string;
  priority: number;
  classroom?: string;
  classTimes: ClassTime[];
}

export interface AddWishlistRequest {
  courseId: number;
  priority: number;
}

// Timetable
export interface TimetableItem {
  id: number;
  courseId: number;
  courseName: string;
  professor: string;
  classroom?: string;
  classTimes: ClassTime[];
}

export interface TimetableCourse {
  courseId: number;
  courseName: string;
  professor: string;
  classroom?: string;
  classTimes: ClassTime[];
}

export interface Timetable {
  id: number;
  name: string;
  openingYear: number;
  semester: string;
  excludedCourses: TimetableCourse[];
  items: TimetableItem[];
}

export interface CreateTimetableRequest {
  name: string;
  openingYear: number;
  semester: string;
}

export interface UpdateTimetableRequest {
  name?: string;
  courseIds?: number[];
  excludedCourseIds?: number[];
}

export interface CreateAlternativeRequest {
  name: string;
  excludedCourseIds: number[];
}

// Scenario
export interface Scenario {
  id: number;
  name: string;
  description?: string;
  parentId?: number;
  timetableId: number;
  timetable: Timetable;
  failedCourseIds: number[];
  children: Scenario[];
}

export interface CreateScenarioRequest {
  name: string;
  description?: string;
  timetableId: number;
}

export interface CreateAlternativeScenarioRequest {
  name: string;
  timetableId: number;
  failedCourseIds: number[];
}

// Registration
export type RegistrationStatus = 'inProgress' | 'completed' | 'cancelled';

export interface RegistrationStep {
  id: number;
  scenarioId: number;
  scenarioName: string;
  succeededCourses: number[];
  failedCourses: number[];
  canceledCourses: number[];
  nextScenarioId?: number;
  nextScenarioName?: string;
  notes?: string;
}

export interface Registration {
  id: number;
  userId: number;
  name?: string;
  startScenario: Scenario;
  currentScenario: Scenario;
  status: RegistrationStatus;
  succeededCourses: number[];
  failedCourses: number[];
  canceledCourses: number[];
  steps: RegistrationStep[];
}

export interface CreateRegistrationRequest {
  name: string;
  scenarioId: number;
}

export interface AddStepRequest {
  succeededCourses: number[];
  failedCourses: number[];
  canceledCourses: number[];
  nextScenarioId?: number;
  notes?: string;
}
