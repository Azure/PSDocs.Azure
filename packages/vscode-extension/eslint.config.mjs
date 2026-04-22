// @ts-check
import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

export default tseslint.config(
    {
        files: ["src/**/*.ts"],
        extends: [
            eslint.configs.recommended,
            ...tseslint.configs.recommended,
        ],
        rules: {
            "@typescript-eslint/naming-convention": "warn",
            "curly": "warn",
            "eqeqeq": "warn",
            "no-throw-literal": "warn",
            // Relax rules that the original .eslintrc.json didn't enforce
            "@typescript-eslint/no-require-imports": "off",
            "@typescript-eslint/no-explicit-any": "off",
            "@typescript-eslint/no-unused-vars": "off",
            "no-var": "off",
            "prefer-const": "off",
        },
    },
    {
        ignores: ["out/", "dist/", "**/*.d.ts"],
    }
);
