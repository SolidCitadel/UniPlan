import { apiClient, API_ENDPOINTS } from './client';
import type { Scenario, CreateScenarioRequest, CreateAlternativeScenarioRequest } from '@/types';

export const scenarioApi = {
  getAll: async (): Promise<Scenario[]> => {
    const response = await apiClient.get<Scenario[]>(API_ENDPOINTS.SCENARIOS);
    return response.data;
  },

  getById: async (id: number): Promise<Scenario> => {
    const response = await apiClient.get<Scenario>(`${API_ENDPOINTS.SCENARIOS}/${id}`);
    return response.data;
  },

  create: async (data: CreateScenarioRequest): Promise<Scenario> => {
    const response = await apiClient.post<Scenario>(API_ENDPOINTS.SCENARIOS, data);
    return response.data;
  },

  update: async (id: number, data: Partial<CreateScenarioRequest>): Promise<Scenario> => {
    const response = await apiClient.patch<Scenario>(`${API_ENDPOINTS.SCENARIOS}/${id}`, data);
    return response.data;
  },

  delete: async (id: number): Promise<void> => {
    await apiClient.delete(`${API_ENDPOINTS.SCENARIOS}/${id}`);
  },

  createAlternative: async (
    parentId: number,
    data: CreateAlternativeScenarioRequest
  ): Promise<Scenario> => {
    const response = await apiClient.post<Scenario>(
      `${API_ENDPOINTS.SCENARIOS}/${parentId}/alternatives`,
      data
    );
    return response.data;
  },
};
