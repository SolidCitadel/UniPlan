import axios from 'axios';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080';

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor - add auth token
apiClient.interceptors.request.use(
  (config) => {
    if (typeof window !== 'undefined') {
      const token = localStorage.getItem('accessToken');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor - handle 401
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    const requestUrl = error.config?.url || '';
    const isAuthEndpoint = requestUrl.includes('/auth/');

    // 인증 API(로그인/회원가입)에서의 401은 자격증명 오류이므로 리다이렉트하지 않음
    if (error.response?.status === 401 && !isAuthEndpoint) {
      if (typeof window !== 'undefined') {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export const API_ENDPOINTS = {
  // Auth
  AUTH_LOGIN: '/api/v1/auth/login',
  AUTH_SIGNUP: '/api/v1/auth/signup',
  AUTH_REFRESH: '/api/v1/auth/refresh',
  USER_ME: '/api/v1/users/me',

  // Resources
  COURSES: '/api/v1/courses',
  TIMETABLES: '/api/v1/timetables',
  WISHLIST: '/api/v1/wishlist',
  SCENARIOS: '/api/v1/scenarios',
  REGISTRATIONS: '/api/v1/registrations',
} as const;
