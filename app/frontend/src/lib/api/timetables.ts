import { apiClient, API_ENDPOINTS } from './client';
import type {
  Timetable,
  CreateTimetableRequest,
  UpdateTimetableRequest,
  CreateAlternativeRequest,
} from '@/types';

export const timetableApi = {
  getAll: async (): Promise<Timetable[]> => {
    const response = await apiClient.get<Timetable[]>(API_ENDPOINTS.TIMETABLES);
    return response.data;
  },

  getById: async (id: number): Promise<Timetable> => {
    const response = await apiClient.get<Timetable>(`${API_ENDPOINTS.TIMETABLES}/${id}`);
    return response.data;
  },

  create: async (data: CreateTimetableRequest): Promise<Timetable> => {
    const response = await apiClient.post<Timetable>(API_ENDPOINTS.TIMETABLES, data);
    return response.data;
  },

  update: async (id: number, data: UpdateTimetableRequest): Promise<Timetable> => {
    const response = await apiClient.patch<Timetable>(`${API_ENDPOINTS.TIMETABLES}/${id}`, data);
    return response.data;
  },

  delete: async (id: number): Promise<void> => {
    await apiClient.delete(`${API_ENDPOINTS.TIMETABLES}/${id}`);
  },

  createAlternative: async (baseTimetableId: number, data: CreateAlternativeRequest): Promise<Timetable> => {
    const response = await apiClient.post<Timetable>(
      `${API_ENDPOINTS.TIMETABLES}/${baseTimetableId}/alternatives`,
      data
    );
    return response.data;
  },

  addCourse: async (timetableId: number, courseId: number): Promise<Timetable> => {
    const response = await apiClient.post<Timetable>(
      `${API_ENDPOINTS.TIMETABLES}/${timetableId}/courses/${courseId}`
    );
    return response.data;
  },

  removeCourse: async (timetableId: number, courseId: number): Promise<Timetable> => {
    const response = await apiClient.delete<Timetable>(
      `${API_ENDPOINTS.TIMETABLES}/${timetableId}/courses/${courseId}`
    );
    return response.data;
  },
};
