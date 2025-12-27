import { apiClient, API_ENDPOINTS } from './client';
import type { Registration, CreateRegistrationRequest, AddStepRequest } from '@/types';

export const registrationApi = {
  getAll: async (): Promise<Registration[]> => {
    const response = await apiClient.get<Registration[]>(API_ENDPOINTS.REGISTRATIONS);
    return response.data;
  },

  getById: async (id: number): Promise<Registration> => {
    const response = await apiClient.get<Registration>(`${API_ENDPOINTS.REGISTRATIONS}/${id}`);
    return response.data;
  },

  create: async (data: CreateRegistrationRequest): Promise<Registration> => {
    const response = await apiClient.post<Registration>(API_ENDPOINTS.REGISTRATIONS, data);
    return response.data;
  },

  addStep: async (id: number, data: AddStepRequest): Promise<Registration> => {
    const response = await apiClient.post<Registration>(
      `${API_ENDPOINTS.REGISTRATIONS}/${id}/steps`,
      data
    );
    return response.data;
  },

  complete: async (id: number): Promise<Registration> => {
    const response = await apiClient.post<Registration>(
      `${API_ENDPOINTS.REGISTRATIONS}/${id}/complete`
    );
    return response.data;
  },

  cancel: async (id: number): Promise<Registration> => {
    const response = await apiClient.post<Registration>(
      `${API_ENDPOINTS.REGISTRATIONS}/${id}/cancel`
    );
    return response.data;
  },

  delete: async (id: number): Promise<void> => {
    await apiClient.delete(`${API_ENDPOINTS.REGISTRATIONS}/${id}`);
  },
};
