FROM gcc:4.9
RUN mkdir -p /usr/src/mem_hoarder
COPY mem_hoarder.c /usr/src/mem_hoarder
WORKDIR /usr/src/mem_hoarder
RUN gcc -o mem_hoarder mem_hoarder.c
CMD ["./mem_hoarder"]
