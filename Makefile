##############
# parameters #
##############
# do you want to show the commands executed ?
DO_MKDBG:=0
# do you want dependency on the makefile itself ?!?
DO_ALLDEP:=1
# do you want to do 'ppt' from 'odp'?
DO_FMT_YAML_JSON:=1

########
# code #
########
ALL:=

# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

# markdown
YAML_SRC:=$(shell find yaml -type f -and -name "*.yaml")
YAML_BAS:=$(basename $(YAML_SRC))
YAML_JSON:=$(addprefix out/,$(addsuffix .json,$(YAML_BAS)))
ifeq ($(DO_FMT_YAML_JSON),1)
ALL+=$(YAML_JSON)
endif # DO_FMT_YAML_JSON

#########
# rules #
#########
.PHONY: all
all: $(ALL)
	@true

# json
$(YAML_JSON): out/%.json: %.yaml
	$(info doing [$@])
	$(Q)mkdir -p $(dir $@)
	$(Q)yq < $< > $@

.PHONY: debug
debug:
	$(info doing [$@])
	$(info ALL is $(ALL))
	$(info YAML_JSON is $(YAML_JSON))

.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)rm -f $(ALL)

.PHONY: clean_hard
clean_hard:
	$(info doing [$@])
	$(Q)git clean -qffxd

##########
# alldep #
##########
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP
