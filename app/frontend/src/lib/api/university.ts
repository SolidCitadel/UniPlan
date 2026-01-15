import { apiClient, API_ENDPOINTS } from './client';
import type { University } from '@/types';

export const universityApi = {
  getAll: async (): Promise<University[]> => {
    const response = await apiClient.get<University[]>(API_ENDPOINTS.UNIVERSITIES);
    return response.data;
  },
};
