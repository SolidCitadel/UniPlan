import { writeFileSync } from 'fs';

const content = `// Auto-generated - DO NOT EDIT
export * as UserService from './user-service';
export * as PlannerService from './planner-service';
export * as CatalogService from './catalog-service';
`;

writeFileSync('src/types/generated/index.ts', content);
console.log('Generated src/types/generated/index.ts');
