GXX = $(shell bash -c "compgen -c g++" | sort -r | head -1)
INCLUDES = -I. $(foreach dir,$(SOURCE_DIR),-I$(dir))
#DEBUG = -g
CXXFLAGS = -std=c++11 -Wall -O2 $(INCLUDES) $(DEBUG)
LDFLAGS  = -pthread
#LDFLAGS = -lrt -lpthread -lboost_regex -L/path/to/boost/lib -pg
LD = $(GXX)
CXX = $(GXX)

TEXT_TEMPLATE = "\033[36mTEXT\033[0m"
COMMA = ","

TARGET = main

SOURCE_DIR = \
$(shell find . -type d \( ! -path '*/.*' -o -prune \) \( ! -name ".*" \))
SOURCE_FILES = \
$(wildcard *.cpp) $(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.cpp))

#OBJS = $(patsubst %.cpp,%.o,$(SOURCE_FILES))
OBJS = $(SOURCE_FILES:.cpp=.o)
DEPS = $(SOURCE_FILES:.cpp=.d)

EXISTED_DEPS = \
$(wildcard *.d) $(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.d))
EXISTED_OBJS = \
$(wildcard *.o) $(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.o))

%.o: %.cpp
	@echo $(subst TEXT,"Compiling $< and Generating its Dependencies ...",$(TEXT_TEMPLATE))
	$(CXX) -c $(CXXFLAGS) -MMD -o $@ $<

$(TARGET): $(OBJS)
	@echo $(subst TEXT,"Generating Target file: $@ ...",$(TEXT_TEMPLATE))
	$(LD) $^ -o $@ $(LDFLAGS)
	@echo $(subst TEXT,"All Done.",$(TEXT_TEMPLATE))

-include $(DEPS)

clean:
	@echo $(subst TEXT,"Removing $(TARGET).",$(TEXT_TEMPLATE))
	@$(RM) $(TARGET)
	@echo $(subst TEXT,"Removing Object Files.",$(TEXT_TEMPLATE))
	@$(RM) $(EXISTED_OBJS)
	@echo $(subst TEXT,"Removing Dependency Files.",$(TEXT_TEMPLATE))
	@$(RM) $(EXISTED_DEPS)
	@echo $(subst TEXT,"All Clean.",$(TEXT_TEMPLATE))

.PHONY: clean
