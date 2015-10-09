package org.pascani.deployment.amelia.process;

import static net.sf.expectit.matcher.Matchers.regexp;

import java.util.concurrent.Callable;

import org.pascani.deployment.amelia.DeploymentException;
import org.pascani.deployment.amelia.descriptors.CompilationDescriptor;
import org.pascani.deployment.amelia.util.ShellUtils;

import net.sf.expectit.Expect;

public class Compile implements Callable<Boolean> {

	private final Expect expect;

	private final CompilationDescriptor descriptor;

	public Compile(final Expect expect, final CompilationDescriptor descriptor) {
		this.expect = expect;
		this.descriptor = descriptor;
	}

	public Boolean call() throws Exception {

		// The Amelia prompt
		String prompt = ShellUtils.ameliaPromptRegexp();

		// Perform the compilation
		this.expect.sendLine(descriptor.toCommandString());
		String compile = this.expect.expect(regexp(prompt)).getBefore();

		if (compile.contains("No such file or directory"))
			throw new DeploymentException("No such file or directory \""
					+ descriptor.sourceDirectory() + "\"");

		return true;
	}

}