import * as os from 'os';
import * as path from 'path';

import { runTests } from '@vscode/test-electron';

async function main() {
	try {
		// The folder containing the Extension Manifest package.json
		// Passed to `--extensionDevelopmentPath`
		const extensionDevelopmentPath = path.resolve(__dirname, '../../');

		// The path to test runner
		// Passed to --extensionTestsPath
		const extensionTestsPath = path.resolve(__dirname, './suite/index');

		// Use a short user-data-dir under the OS temp directory. The default
		// location inside .vscode-test produces an IPC socket path that exceeds
		// the macOS 103-character Unix domain socket limit, which aborts launch.
		const userDataDir = path.join(os.tmpdir(), 'vscode-test-ud');

		// Download VS Code, unzip it and run the integration test
		await runTests({
			extensionDevelopmentPath,
			extensionTestsPath,
			launchArgs: ['--user-data-dir', userDataDir],
		});
	} catch (err) {
		console.error('Failed to run tests');
		process.exit(1);
	}
}

main();
