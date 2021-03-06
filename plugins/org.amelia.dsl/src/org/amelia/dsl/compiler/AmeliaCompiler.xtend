/*
 * Copyright © 2015 Universidad Icesi
 * 
 * This file is part of the Amelia project.
 * 
 * The Amelia project is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 * 
 * The Amelia project is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
 * for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with The Amelia project. If not, see <http://www.gnu.org/licenses/>.
 */
package org.amelia.dsl.compiler

import org.amelia.dsl.amelia.CdCommand
import org.amelia.dsl.amelia.CommandLiteral
import org.amelia.dsl.amelia.CompileCommand
import org.amelia.dsl.amelia.CustomCommand
import org.amelia.dsl.amelia.EvalCommand
import org.amelia.dsl.amelia.RichString
import org.amelia.dsl.amelia.RichStringLiteral
import org.amelia.dsl.amelia.RunCommand
import org.amelia.dsl.lib.descriptors.CommandDescriptor
import org.amelia.dsl.lib.util.Commands
import org.eclipse.xtext.util.Strings
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.compiler.Later
import org.eclipse.xtext.xbase.compiler.XbaseCompiler
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable
import org.amelia.dsl.amelia.TransferCommand

/**
 * @author Miguel Jiménez - Initial contribution and API
 */
class AmeliaCompiler extends XbaseCompiler {

	override internalToConvertedExpression(XExpression obj, ITreeAppendable appendable) {
		switch (obj) {
			CdCommand: _toJavaExpression(obj, appendable)
			CompileCommand: _toJavaExpression(obj, appendable)
			CustomCommand: _toJavaExpression(obj, appendable)
			EvalCommand: _toJavaExpression(obj, appendable)
			RunCommand: _toJavaExpression(obj, appendable)
			TransferCommand: _toJavaExpression(obj, appendable)
			RichString: _toJavaExpression(obj, appendable)
			default: super.internalToConvertedExpression(obj, appendable)
		}
	}

	override doInternalToJavaStatement(XExpression expr, ITreeAppendable appendable, boolean isReferenced) {
		switch (expr) {
			CommandLiteral: _toJavaStatement(expr, appendable, isReferenced)
			RichString: _toJavaStatement(expr, appendable, isReferenced)
			default: super.doInternalToJavaStatement(expr, appendable, isReferenced)
		}
	}
	
	override protected boolean isVariableDeclarationRequired(XExpression expr, ITreeAppendable b, boolean recursive) {
		switch (expr) {
			CommandLiteral: return false
			default: return super.isVariableDeclarationRequired(expr, b, true)
		}
	}
	
	def protected void _toJavaStatement(CommandLiteral expr, ITreeAppendable t, boolean isReferenced) {
		val appendable = t.trace(expr)
		if (!isReferenced) {
			internalToConvertedExpression(expr, appendable);
			appendable.append(";");
		} else if (isVariableDeclarationRequired(expr, appendable, true)) {
			val later = new Later() {
				override void exec(ITreeAppendable appendable) {
					internalToConvertedExpression(expr, appendable);
				}
			};
			declareFreshLocalVariable(expr, appendable, later);
		}
	}
	
	def protected String formatCommandText(String value, boolean escapeClosingComment) {
		var _value = if (escapeClosingComment)
				value.replaceAll("\\\\* \\/", "\\\\* \\/")
			else
				value
		_value = _value
			.substring(1, value.length - 1)
			.replaceAll("\\\\\"", "\\\"")
			.replaceAll("\\\\'", "'")
			.replaceAll("\\\\\\«", "«")
			.replaceAll("\\\\\\»", "»")
		var lines = _value.split("\n")
		if (lines.length > 1)
			lines = lines.map[l|l.replaceAll("^\\s+", "")] // left trim
		return lines.map[l|Strings.convertToJavaString(l, true)].filter[l|!l.isEmpty].join(" ")
	}
	
	def protected void compileTemplate(RichString literal, ITreeAppendable t) {
		compileTemplate(literal, t.trace(literal), false)
	}
	
	def protected void compileTemplate(RichString literal, ITreeAppendable appendable, boolean escapeClosingComment) {
		appendable.append("\"")
		for (part : literal.expressions) {
			switch (part) {
				RichStringLiteral:
					appendable.append(part.value.formatCommandText(escapeClosingComment))
				XExpression: {
					appendable.append("\" + ")
					internalToConvertedExpression(part, appendable)
					appendable.append(" + \"")
				}
			}
		}
		appendable.append("\"")
	}
	
	def void _toJavaExpression(RichString expr, ITreeAppendable b) {
		compileTemplate(expr, b)
	}
	
	def protected void _toJavaStatement(RichString expr, ITreeAppendable t, boolean isReferenced) {
		val appendable = t.trace(expr)
		generateComment(new Later() {
			override void exec(ITreeAppendable appendable) {
				compileTemplate(expr, appendable, true)
			}
		}, appendable, isReferenced);
	}
	
	def protected void _toJavaExpression(CustomCommand expr, ITreeAppendable t) {
		val appendable = t.trace(expr)
		if (expr.initializedLater) {
			appendable.append("new ").append(CommandDescriptor.Builder).append("()")
			appendable.increaseIndentation.increaseIndentation
			appendable.newLine.append(".withCommand(")
			internalToConvertedExpression(expr.value, appendable)
			appendable.append(")")
			appendable.decreaseIndentation.decreaseIndentation
		} else {
			appendable.append(Commands).append(".generic(")
			internalToConvertedExpression(expr.value, appendable)
			appendable.append(")")
		}
	}
	
	def protected void _toJavaExpression(EvalCommand expr, ITreeAppendable t) {
		val appendable = t.trace(expr)
		appendable.append(Commands)
		appendable.append(".evalFScript(")
		internalToConvertedExpression(expr.script, appendable)
		appendable.append(", ")
		if (expr.uri !== null)
			internalToConvertedExpression(expr.uri, appendable)
		else
			appendable
				.append("org.pascani.dsl.lib.sca.FrascatiUtils")
				.append(".DEFAULT_BINDING_URI")
		appendable.append(")")
	}
	
	def protected void _toJavaExpression(CdCommand expr, ITreeAppendable t) {
		val appendable = t.trace(expr)
		appendable.append(Commands)
		if (expr.initializedLater)
			appendable.append(".cdBuilder")
		else
			appendable.append(".cd")
		appendable.append("(")
		internalToConvertedExpression(expr.directory, appendable)
		appendable.append(")")
	}
	
	def protected void _toJavaExpression(TransferCommand expr, ITreeAppendable t) {
		val appendable = t.trace(expr)
		appendable.append(Commands)
		appendable.append(".scp")
		appendable.append("(")
		internalToConvertedExpression(expr.source, appendable)
		appendable.append(", ")
		internalToConvertedExpression(expr.destination, appendable)
		appendable.append(", true)")
	}
	
	def protected void _toJavaExpression(CompileCommand expr, ITreeAppendable t) {
		val appendable = t.trace(expr)
		appendable.append(Commands)
		if (expr.initializedLater)
			appendable.append(".compileBuilder")
		else
			appendable.append(".compile")
		appendable.append("(")
		internalToConvertedExpression(expr.source, appendable)
		appendable.append(", ")
		internalToConvertedExpression(expr.output, appendable)
		if (expr.classpath !== null) {
			appendable.append(", ")
			internalToConvertedExpression(expr.classpath, appendable)
		}
		appendable.append(")")
	}
	
	def protected void _toJavaExpression(RunCommand expr, ITreeAppendable t) {
		val appendable = t.trace(expr)
		appendable.append(Commands).append(".run").append("()")
		appendable.increaseIndentation.increaseIndentation
		
		appendable.newLine.append(".withComposite(")
		internalToConvertedExpression(expr.composite, appendable)
		appendable.append(")")
		
		appendable.newLine.append(".withLibpath(")
		internalToConvertedExpression(expr.libpath, appendable)
		appendable.append(")")
		if (expr.hasPort) {
			appendable.newLine.append(".withPort(")
			internalToConvertedExpression(expr.port, appendable)
			appendable.append(")")
		}
		if (expr.hasService) {
			appendable.newLine.append(".withService(")
			internalToConvertedExpression(expr.service, appendable)
			appendable.append(")")
		}
		if (expr.hasMethod) {
			appendable.newLine.append(".withMethod(")
			internalToConvertedExpression(expr.method, appendable)
			appendable.append(")")
		}
		if (expr.hasParams) {
			appendable.newLine.append(".withArguments(")
			internalToConvertedExpression(expr.params, appendable)
			appendable.append(")")
		}
		if (!expr.initializedLater)
			appendable.append(".build()")
		appendable.decreaseIndentation.decreaseIndentation
	}

}
