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
 * along with the Amelia project. If not, see <http://www.gnu.org/licenses/>.
 */
package org.amelia.dsl.lib;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.amelia.dsl.lib.util.Log;

/**
 * @author Miguel Jiménez - Initial contribution and API
 */
public class Subsystem {

	public abstract static class Deployment extends OpenObservable {

		protected DescriptorGraph graph;
		
		public abstract void deploy(String subsystem,
				List<Subsystem> dependencies) throws Exception;
		
		public void shutdownAndStopComponents(String... compositeNames) {
			this.graph.shutdown(compositeNames);
		}
		
		public void shutdown(boolean stopAllExecutedComponents) {
			this.graph.shutdown(stopAllExecutedComponents);
		}
		
		public boolean isShutdown() {
			return this.graph == null
					|| this.graph.isShuttingDown();
		}
		
		public void releaseDependencies(Collection<Subsystem> dependencies) {
			for (Subsystem dependency : dependencies) {
				if (!dependency.deployment().isShutdown()) {
					dependency.deployment().shutdown(true);
				}
			}
		}
		
		/**
		 * <b>Note</b>: DSL-only intended use
		 */
		public void setup() {}
	}
	
	private final UUID uuid;

	private final String alias;

	private final Deployment deployment;
	
	private final List<Subsystem> dependencies;

	public Subsystem(final String alias, final Deployment deployment) {
		this.uuid = UUID.randomUUID();
		this.alias = alias;
		this.deployment = deployment;
		this.dependencies = new ArrayList<Subsystem>();
	}

	public void start() {
		Log.print(Log.SEPARATOR_LONG);
		Log.print("Deploying subsystem '" + alias + "'");
		Log.print(Log.SEPARATOR_LONG);
	}

	public void error() {
		Log.error(null, "Error deploying subsystem '" + alias + "'");
	}

	public void done() {
		Log.info("Finished deploying subsystem '" + alias + "'");
	}
	
	public boolean dependsOn(Subsystem... subsystems) {
		boolean all = true;
		for (Subsystem subsystem : subsystems) {
			if (subsystem.equals(this))
				throw new IllegalArgumentException("A subsystem cannot depend on itself");
			if (this.dependencies.contains(subsystem)) {
				all = false;
				continue;
			}
			this.dependencies.add(subsystem);
		}
		return all;
	}
	
	public List<Subsystem> dependencies() {
		return this.dependencies;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((uuid == null) ? 0 : uuid.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Subsystem other = (Subsystem) obj;
		if (uuid == null) {
			if (other.uuid != null)
				return false;
		} else if (!uuid.equals(other.uuid))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return this.alias;
	}

	public Deployment deployment() {
		return this.deployment;
	}

	public String alias() {
		return this.alias;
	}

}
