import { AxiosError } from 'axios';
import { ApiError } from '@/types';

/**
 * Axios 에러에서 백엔드 메시지를 추출합니다.
 * - 네트워크 에러: 연결 실패 메시지
 * - 500 에러: 서버 오류 고정 메시지
 * - 그 외: 백엔드 메시지 또는 fallback
 */
export function getErrorMessage(error: unknown, fallback = '오류가 발생했습니다'): string {
  if (error instanceof AxiosError) {
    const axiosError = error as AxiosError<ApiError>;

    // 네트워크 에러 (응답 자체가 없음)
    if (!axiosError.response) {
      if (axiosError.code === 'ERR_NETWORK') {
        return '서버에 연결할 수 없습니다. 네트워크 연결을 확인해주세요.';
      }
      if (axiosError.code === 'ECONNABORTED') {
        return '요청 시간이 초과되었습니다. 다시 시도해주세요.';
      }
      return '서버와 통신할 수 없습니다.';
    }

    const status = axiosError.response.status;

    // 500 에러는 서버 문제이므로 고정 메시지
    if (status === 500) {
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }

    // 백엔드 메시지가 있으면 사용
    const message = axiosError.response.data?.message;
    if (message) {
      return message;
    }
  }

  return fallback;
}
