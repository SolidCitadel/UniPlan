import { apiClient, API_ENDPOINTS } from './client';
import type { Course, CourseSearchParams, Page } from '@/types';

export const courseApi = {
  search: async (params: CourseSearchParams = {}): Promise<Page<Course>> => {
    const response = await apiClient.get<Page<Course>>(API_ENDPOINTS.COURSES, {
      params: {
        courseName: params.query,
        professor: params.professor,
        departmentName: params.departmentName,
        campus: params.campus,
        targetGrade: params.targetGrade,
        credits: params.credits,
        page: params.page ?? 0,
        size: params.size ?? 20,
      },
    });
    return response.data;
  },

  getById: async (id: number): Promise<Course> => {
    const response = await apiClient.get<Course>(`${API_ENDPOINTS.COURSES}/${id}`);
    return response.data;
  },
};
