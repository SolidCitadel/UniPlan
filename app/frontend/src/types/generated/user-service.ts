// Auto-generated from OpenAPI - DO NOT EDIT MANUALLY
// Run `npm run types:generate` to regenerate this file
//
// This is a placeholder file. The actual types will be generated
// when you run `npm run types:generate` with the backend running.

export interface components {
  schemas: {
    AuthResponse: {
      accessToken: string;
      refreshToken: string;
      user: components['schemas']['UserResponse'];
    };
    UserResponse: {
      id: number;
      email: string;
      name: string;
      role: string;
      universityId: number;
      universityName: string;
    };
    LoginRequest: {
      email: string;
      password: string;
    };
    SignupRequest: {
      email: string;
      password: string;
      name: string;
      universityId: number;
    };
    UniversityResponse: {
      id: number;
      name: string;
      code: string;
    };
  };
}

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface paths {}
// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface operations {}
