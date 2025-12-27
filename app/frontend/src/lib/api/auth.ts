import { apiClient, API_ENDPOINTS } from './client';
import type { LoginRequest, LoginResponse, SignupRequest, User } from '@/types';

export const authApi = {
  login: async (data: LoginRequest): Promise<LoginResponse> => {
    const response = await apiClient.post<LoginResponse>(API_ENDPOINTS.AUTH_LOGIN, data);
    return response.data;
  },

  signup: async (data: SignupRequest): Promise<void> => {
    await apiClient.post(API_ENDPOINTS.AUTH_SIGNUP, data);
  },

  getMe: async (): Promise<User> => {
    const response = await apiClient.get<User>(API_ENDPOINTS.USER_ME);
    return response.data;
  },

  refresh: async (refreshToken: string): Promise<LoginResponse> => {
    const response = await apiClient.post<LoginResponse>(API_ENDPOINTS.AUTH_REFRESH, {
      refreshToken,
    });
    return response.data;
  },
};
