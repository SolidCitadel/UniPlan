import type { components as UserComponents } from './generated/user-service';
import type { components as PlannerComponents } from './generated/planner-service';
import type { components as CatalogComponents } from './generated/catalog-service';

// ============================================
// Auth (user-service)
// ============================================
export type LoginResponse = UserComponents['schemas']['AuthResponse'];
export type User = UserComponents['schemas']['UserInfo'];
export type LoginRequest = UserComponents['schemas']['LoginRequest'];
export type SignupRequest = UserComponents['schemas']['SignupRequest'];

// ============================================
// University (user-service)
// ============================================
export type University = UserComponents['schemas']['UniversityResponse'];

// ============================================
// Course (catalog-service)
// ============================================
export type Course = CatalogComponents['schemas']['CourseResponse'];
export type ClassTime = CatalogComponents['schemas']['ClassTimeResponse'];

// ============================================
// Timetable (planner-service)
// ============================================
export type Timetable = PlannerComponents['schemas']['TimetableResponse'];
export type TimetableItem = PlannerComponents['schemas']['TimetableItemResponse'];
export type TimetableCourse = PlannerComponents['schemas']['TimetableCourseResponse'];
export type CreateTimetableRequest = PlannerComponents['schemas']['CreateTimetableRequest'];
export type UpdateTimetableRequest = PlannerComponents['schemas']['UpdateTimetableRequest'];
export type CreateAlternativeRequest = PlannerComponents['schemas']['CreateAlternativeTimetableRequest'];

// ============================================
// Wishlist (planner-service)
// ============================================
export type WishlistItem = PlannerComponents['schemas']['WishlistItemResponse'];
export type AddWishlistRequest = PlannerComponents['schemas']['AddToWishlistRequest'];

// ============================================
// Scenario (planner-service)
// ============================================
export type Scenario = PlannerComponents['schemas']['ScenarioResponse'];
export type CreateScenarioRequest = PlannerComponents['schemas']['CreateScenarioRequest'];
export type CreateAlternativeScenarioRequest = PlannerComponents['schemas']['CreateAlternativeScenarioRequest'];

// ============================================
// Registration (planner-service)
// ============================================
export type Registration = PlannerComponents['schemas']['RegistrationResponse'];
export type RegistrationStep = PlannerComponents['schemas']['RegistrationStepResponse'];
export type RegistrationStatus = 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED';
export type CreateRegistrationRequest = PlannerComponents['schemas']['StartRegistrationRequest'];
export type AddStepRequest = PlannerComponents['schemas']['AddStepRequest'];
