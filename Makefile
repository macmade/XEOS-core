#-------------------------------------------------------------------------------
# Copyright (c) 2010-2013, Jean-David Gadina - www.xs-labs.com
# All rights reserved.
# 
# XEOS Software License - Version 1.0 - December 21, 2012
# 
# Permission is hereby granted, free of charge, to any person or organisation
# obtaining a copy of the software and accompanying documentation covered by
# this license (the "Software") to deal in the Software, with or without
# modification, without restriction, including without limitation the rights
# to use, execute, display, copy, reproduce, transmit, publish, distribute,
# modify, merge, prepare derivative works of the Software, and to permit
# third-parties to whom the Software is furnished to do so, all subject to the
# following conditions:
# 
#       1.  Redistributions of source code, in whole or in part, must retain the
#           above copyright notice and this entire statement, including the
#           above license grant, this restriction and the following disclaimer.
# 
#       2.  Redistributions in binary form must reproduce the above copyright
#           notice and this entire statement, including the above license grant,
#           this restriction and the following disclaimer in the documentation
#           and/or other materials provided with the distribution, unless the
#           Software is distributed by the copyright owner as a library.
#           A "library" means a collection of software functions and/or data
#           prepared so as to be conveniently linked with application programs
#           (which use some of those functions and data) to form executables.
# 
#       3.  The Software, or any substancial portion of the Software shall not
#           be combined, included, derived, or linked (statically or
#           dynamically) with software or libraries licensed under the terms
#           of any GNU software license, including, but not limited to, the GNU
#           General Public License (GNU/GPL) or the GNU Lesser General Public
#           License (GNU/LGPL).
# 
#       4.  All advertising materials mentioning features or use of this
#           software must display an acknowledgement stating that the product
#           includes software developed by the copyright owner.
# 
#       5.  Neither the name of the copyright owner nor the names of its
#           contributors may be used to endorse or promote products derived from
#           this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT OWNER AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, TITLE AND NON-INFRINGEMENT ARE DISCLAIMED.
# 
# IN NO EVENT SHALL THE COPYRIGHT OWNER, CONTRIBUTORS OR ANYONE DISTRIBUTING
# THE SOFTWARE BE LIABLE FOR ANY CLAIM, DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN ACTION OF CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#-------------------------------------------------------------------------------

# $Id$

include ../../Makefile-Config.mk

#-------------------------------------------------------------------------------
# Display
#-------------------------------------------------------------------------------

PROMPT              := "    ["$(COLOR_GREEN)" XEOS "$(COLOR_NONE)"]> ["$(COLOR_GREEN)" SRC  "$(COLOR_NONE)"]> ["$(COLOR_GREEN)" CORE "$(COLOR_NONE)"]>           *** "

#-------------------------------------------------------------------------------
# Software arguments
#-------------------------------------------------------------------------------

ARGS_LD_32          := -T linker.ld $(ARGS_LD_32)
ARGS_LD_64          := -T linker.ld $(ARGS_LD_64)

#-------------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------------

XEOS_LIBS           := -lc99 -lposix -lpthread -liconv -lsystem -lblocks -ldispatch -lobjc -lelf

#-------------------------------------------------------------------------------
# Built-in targets
#-------------------------------------------------------------------------------

# Declaration for phony targets, to avoid problems with local files
.PHONY: all clean

#-------------------------------------------------------------------------------
# Phony targets
#-------------------------------------------------------------------------------

# Build the full project
all:
	
	@$(PRINT) $(PROMPT)$(COLOR_CYAN)"Building the ACPI subsystem"$(COLOR_NONE)
	@$(CD) $(PATH_SRC_CORE_ACPI) && $(MAKE) $(ARGS_MAKE)
	
	@$(PRINT) $(PROMPT)$(COLOR_CYAN)"Building the XEOS kernel"$(COLOR_NONE)
	@$(CD) $(PATH_SRC_CORE_KERNEL) && $(MAKE) $(ARGS_MAKE)
	
	@$(PRINT) $(PROMPT)$(COLOR_CYAN)"Linking the XEOS kernel"$(COLOR_NONE)" [ 32 bits ]: "$(COLOR_GRAY)"XEOS32.ELF"$(COLOR_NONE)
	@$(LD_32) $(ARGS_LD_32) -o $(PATH_BUILD_32_BIN)XEOS32.ELF $(PATH_BUILD_32_OBJ)core-xeos$(EXT_OBJ) $(PATH_BUILD_32_OBJ)core-acpi$(EXT_OBJ) $(PATH_BUILD_32_OBJ)core-acpi-acpica$(EXT_OBJ) -L$(PATH_BUILD_32_BIN) -static $(XEOS_LIBS)
	
	@$(PRINT) $(PROMPT)$(COLOR_CYAN)"Linking the XEOS kernel"$(COLOR_NONE)" [ 64 bits ]: "$(COLOR_GRAY)"XEOS64.ELF"$(COLOR_NONE)
	@$(LD_64) $(ARGS_LD_64) -o $(PATH_BUILD_64_BIN)XEOS64.ELF $(PATH_BUILD_64_OBJ)core-xeos$(EXT_OBJ) $(PATH_BUILD_64_OBJ)core-acpi$(EXT_OBJ) $(PATH_BUILD_64_OBJ)core-acpi-acpica$(EXT_OBJ) -L$(PATH_BUILD_64_BIN) -static $(XEOS_LIBS)
	
# Cleans the build files
clean:
	
	@$(CD) $(PATH_SRC_CORE_ACPI) && $(MAKE) $(ARGS_MAKE_CLEAN)
	@$(CD) $(PATH_SRC_CORE_KERNEL) && $(MAKE) $(ARGS_MAKE_CLEAN)
	
	@if [ -f $(PATH_BUILD_32_BIN)XEOS32.ELF ]; then $(RM) $(PATH_BUILD_32_BIN)XEOS32.ELF; fi;
	@if [ -f $(PATH_BUILD_64_BIN)XEOS64.ELF ]; then $(RM) $(PATH_BUILD_64_BIN)XEOS64.ELF; fi;
