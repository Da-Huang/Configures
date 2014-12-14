INCLUDES = -I. $(foreach dir,$(SOURCE_DIR),-I$(dir))
CXXFLAGS = -std=c++0x -g -Wall -O2 $(INCLUDES)
LDFLAGS  = -g -Wall -O2
#LDFLAGS = -lrt -lpthread -lboost_regex -L/path/to/boost/lib -pg -g -Wall
LD = g++
CXX = g++

TEXT_TEMPLATE = "\033[36mTEXT\033[0m"
COMMA = ","

TARGET = main

SOURCE_DIR = \
$(shell find . -type d \( ! -path '*/.*' -o -prune \) \( ! -name ".*" \))
SOURCE_FILES = \
$(wildcard *.cpp) $(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.cpp))

#$(patsubst %,$(wildcard %/*.cpp),$(SOURCE_DIR))# $(wildcard field/*.cpp)
OBJS = $(patsubst %.cpp,%.o,$(SOURCE_FILES))
DEPS = $(patsubst %.cpp,%.d,$(SOURCE_FILES))
OUTS = \
$(wildcard *.o) $(wildcard *.d) $(wildcard *.out) \
$(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.o)) \
$(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.d)) \
$(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.out))
#OBJS = $(SOURCE_FILES:.cpp=.o)
#DEPS = $(SOURCE_FILES:.cpp=.d)

%.o: %.cpp
	@echo $(subst TEXT,"Compiling $< and Generating its Dependencies ...",$(TEXT_TEMPLATE))
	$(CXX) -c $(CXXFLAGS) -MMD -o $@ $<

$(TARGET): $(OBJS)
	@echo $(subst TEXT,"Generating Target file: $@ ...",$(TEXT_TEMPLATE))
	$(LD) $^ -o $@ $(LDFLAGS)
	@echo $(subst TEXT,"All Done.",$(TEXT_TEMPLATE))

-include $(DEPS)

clean:
	@echo $(subst TEXT,"Removing $(TARGET)$(COMMA) Object Files$(COMMA) and Dependency Files.",$(TEXT_TEMPLATE))
	$(RM) $(TARGET)
#	$(RM) $(OBJS)
#	$(RM) $(DEPS)
	$(RM) $(OUTS)
	@echo $(subst TEXT,"Clean.",$(TEXT_TEMPLATE))

.PHONY: clean
