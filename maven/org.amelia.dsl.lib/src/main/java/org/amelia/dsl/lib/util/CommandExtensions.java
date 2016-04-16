/*
 * Copyright © 2015 Universidad Icesi
 * 
 * This file is part of the Amelia library.
 * 
 * The Amelia library is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 * 
 * The Amelia library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
 * for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with the Amelia library. If not, see <http://www.gnu.org/licenses/>.
 */
package org.amelia.dsl.lib.util;

import org.amelia.dsl.lib.descriptors.CommandDescriptor;
import org.eclipse.xtext.xbase.lib.Inline;
import org.eclipse.xtext.xbase.lib.Pure;

/**
 * @author Miguel Jiménez - Initial contribution and API
 */
public class CommandExtensions {
	
	/**
	 * The binary {@code +} operator.
	 * 
	 * @param left
	 *            The command at the left hand side of the plus operand
	 * @param right
	 *            The command at the right hand side of the plus operand
	 * @return A new {@link CommandDescriptor} with the same configuration as
	 *         {@code left}, but augmenting its command with {@code right}.
	 */
	@Pure
	@Inline(value = "$1.augmentWith($2)")
	public static CommandDescriptor operator_plus(
			CommandDescriptor left, CommandDescriptor right) {
		return left.augmentWith(right);
	}

}
