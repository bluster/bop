#
# Makefile for bop webcrawler
#

#Package name
PKG = bop

#Useful directories
BUILD = ./build
SRC = ./src
DOC = ./doc
LIB = ./lib
TEST = ./test

#Compiler
JCC = javac

#Documentation builder
JDOC = javadoc
JDOCFLAGS = -d doc

#Enable debugging and resource flags
JFLAGS = -g -d $(BUILD) -cp $(LIB)

#Unit tester
#JTEST = junit

CLASSES = DbInterface.class

all: classes docs

classes:
	mkdir -p $(BUILD)
	$(JCC) $(JFLAGS) $(SRC)/*.java

docs:
	mkdir -p $(DOC)
	$(JDOC) $(JDOCFLAGS) src/*.java

clean: 
	rm -rf $(BUILD)
	rm -rf $(DOC)
