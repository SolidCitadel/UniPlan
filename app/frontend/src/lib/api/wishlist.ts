import { apiClient, API_ENDPOINTS } from './client';
import type { WishlistItem, AddWishlistRequest } from '@/types';

export const wishlistApi = {
  getAll: async (): Promise<WishlistItem[]> => {
    const response = await apiClient.get<WishlistItem[]>(API_ENDPOINTS.WISHLIST);
    return response.data;
  },

  add: async (data: AddWishlistRequest): Promise<WishlistItem> => {
    const response = await apiClient.post<WishlistItem>(API_ENDPOINTS.WISHLIST, data);
    return response.data;
  },

  updatePriority: async (id: number, priority: number): Promise<WishlistItem> => {
    const response = await apiClient.patch<WishlistItem>(`${API_ENDPOINTS.WISHLIST}/${id}`, {
      priority,
    });
    return response.data;
  },

  remove: async (id: number): Promise<void> => {
    await apiClient.delete(`${API_ENDPOINTS.WISHLIST}/${id}`);
  },
};
