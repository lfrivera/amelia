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
package org.amelia.dsl.ui

import org.amelia.dsl.ui.editor.bracketmatching.AmeliaBracePairProvider
import org.amelia.dsl.ui.highlighting.AmeliaAntlrTokenToAttributeIdMapper
import org.amelia.dsl.ui.highlighting.AmeliaHighlightingConfiguration
import org.amelia.dsl.ui.highlighting.AmeliaSemanticHighlightingCalculator
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.ide.editor.bracketmatching.IBracePairProvider
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.service.SingletonBinding
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration
import org.eclipse.xtext.ui.wizard.IProjectCreator
import org.amelia.dsl.ui.wizard.AmeliaPluginCreator
import org.amelia.dsl.ui.hover.AmeliaDispatchingEObjectTextHover
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider
import org.eclipse.xtext.ui.editor.hover.IEObjectHover
import org.amelia.dsl.ui.hover.AmeliaHoverProvider
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider
import org.amelia.dsl.ui.hover.AmeliaEObjectDocumentationProvider

/**
 * Use this class to register components to be used within the Eclipse IDE.
 * 
 * @author Miguel Jiménez - Initial contribution and API
 */
@FinalFieldsConstructor
class AmeliaUiModule extends AbstractAmeliaUiModule {
	
	override Class<? extends ISemanticHighlightingCalculator> bindIdeSemanticHighlightingCalculator() {
		return AmeliaSemanticHighlightingCalculator
	}

	override Class<? extends IHighlightingConfiguration> bindIHighlightingConfiguration() {
		return AmeliaHighlightingConfiguration
	}
	
	def Class<? extends IHighlightingConfiguration> bindILexicalHighlightingConfiguration() {
		return AmeliaHighlightingConfiguration
	}
	
	override Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindAbstractAntlrTokenToAttributeIdMapper() {
		return AmeliaAntlrTokenToAttributeIdMapper
	}
	
	@SingletonBinding override Class<? extends IBracePairProvider> bindIBracePairProvider() {
		return AmeliaBracePairProvider
	}

	override Class<? extends IProjectCreator> bindIProjectCreator() {
		return AmeliaPluginCreator
	}

	override Class<? extends IEObjectHover> bindIEObjectHover() {
        return AmeliaDispatchingEObjectTextHover
    }
 
    override Class<? extends IEObjectHoverProvider> bindIEObjectHoverProvider() {
        return AmeliaHoverProvider
    }

	def Class<? extends IEObjectDocumentationProvider> bindIEObjectDocumentationProviderr() {
        return AmeliaEObjectDocumentationProvider
    }

}
