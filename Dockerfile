FROM java:8

MAINTAINER Raúl Speroni <rsperoni@magnesium.coop>

ENV CORENLP_ARCHIVE_VERSION=2018-02-27
ENV CORENLP_SPANISH_MODELS=stanford-spanish-corenlp-
ENV CORENLP_ARCHIVE=stanford-corenlp-full-${CORENLP_ARCHIVE_VERSION}.zip \
  CORENLP_SHA1SUM=c4fd33b6085d8ac4e8c6746b2c73d95da42d8da4 \
  CORENLP_PATH=/corenlp \
  CORENLP_SHA1_PATH=corenlp.sha1

RUN wget http://nlp.stanford.edu/software/$CORENLP_ARCHIVE
RUN wget http://nlp.stanford.edu/software/$CORENLP_SPANISH_MODELS$CORENLP_ARCHIVE_VERSION-models.jar
RUN echo "$CORENLP_SHA1SUM $CORENLP_ARCHIVE" > corenlp.sha1 \
RUN sha1sum -c corenlp.sha1
RUN unzip $CORENLP_ARCHIVE
RUN mv $(basename ../$CORENLP_ARCHIVE .zip) $CORENLP_PATH
RUN mv $CORENLP_SPANISH_MODELS$CORENLP_ARCHIVE_VERSION-models.jar $CORENLP_PATH
RUN rm $CORENLP_ARCHIVE
RUN rm corenlp.sha1

WORKDIR $CORENLP_PATH
RUN export CLASSPATH="`find . -name '*.jar'`"
ADD StanfordCoreNLP-spanish.properties .


EXPOSE 9000

#CMD java -mx4g -cp stanford-corenlp-3.9.1.jar:stanford-spanish-corenlp-2018-02-27-models.jar edu.stanford.nlp.pipeline.StanfordCoreNLPServer -annotators tokenize,ssplit,pos,parse,ner 9000

CMD java -mx4g -cp "*	" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -serverProperties StanfordCoreNLP-spanish.properties
