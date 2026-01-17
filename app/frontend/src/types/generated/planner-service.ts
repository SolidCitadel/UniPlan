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
    TimetableItemResponse: {
      id: number;
      courseId: number;
      courseCode?: string;
      courseName: string;
      professor: string;
      credits?: number;
      classroom?: string;
      campus?: string;
      classTimes: components['schemas']['ClassTimeResponse'][];
      addedAt?: string;
    };
    TimetableCourseResponse: {
      courseId: number;
      courseCode?: string;
      courseName: string;
      professor: string;
      credits?: number;
      classroom?: string;
      campus?: string;
      classTimes: components['schemas']['ClassTimeResponse'][];
    };
    TimetableResponse: {
      id: number;
      userId: number;
      name: string;
      openingYear: number;
      semester: string;
      createdAt: string;
      updatedAt: string;
      items: components['schemas']['TimetableItemResponse'][];
      excludedCourses: components['schemas']['TimetableCourseResponse'][];
    };
    CreateTimetableRequest: {
      name: string;
      openingYear: number;
      semester: string;
    };
    UpdateTimetableRequest: {
      name?: string;
      courseIds?: number[];
      excludedCourseIds?: number[];
    };
    CreateAlternativeRequest: {
      name: string;
      excludedCourseIds: number[];
    };
    WishlistItemResponse: {
      id: number;
      userId: number;
      courseId: number;
      courseName: string;
      professor: string;
      priority: number;
      classroom?: string;
      classTimes: components['schemas']['ClassTimeResponse'][];
      addedAt: string;
    };
    AddToWishlistRequest: {
      courseId: number;
      priority: number;
    };
    ScenarioResponse: {
      id: number;
      userId: number;
      name: string;
      description?: string;
      parentScenarioId?: number;
      failedCourseIds: number[];
      orderIndex?: number;
      timetable: components['schemas']['TimetableResponse'];
      childScenarios: components['schemas']['ScenarioResponse'][];
      createdAt: string;
      updatedAt: string;
    };
    CreateScenarioRequest: {
      name: string;
      description?: string;
      timetableId: number;
    };
    CreateAlternativeScenarioRequest: {
      name: string;
      timetableId: number;
      failedCourseIds: number[];
    };
    RegistrationStatus: 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED';
    RegistrationStepResponse: {
      id: number;
      scenarioId: number;
      scenarioName: string;
      succeededCourses: number[];
      failedCourses: number[];
      canceledCourses: number[];
      nextScenarioId?: number;
      nextScenarioName?: string;
      notes?: string;
      timestamp: string;
    };
    RegistrationResponse: {
      id: number;
      userId: number;
      name?: string;
      startScenario: components['schemas']['ScenarioResponse'];
      currentScenario: components['schemas']['ScenarioResponse'];
      status: components['schemas']['RegistrationStatus'];
      startedAt: string;
      completedAt?: string;
      succeededCourses: number[];
      failedCourses: number[];
      canceledCourses: number[];
      steps: components['schemas']['RegistrationStepResponse'][];
    };
    CreateRegistrationRequest: {
      name?: string;
      scenarioId: number;
    };
    AddStepRequest: {
      succeededCourses: number[];
      failedCourses: number[];
      canceledCourses: number[];
      nextScenarioId?: number;
      notes?: string;
    };
  };
}

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface paths {}
// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface operations {}
