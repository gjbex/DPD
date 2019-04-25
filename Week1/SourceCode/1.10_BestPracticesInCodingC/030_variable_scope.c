long n;
long distrNr;
Particle *p;
int step;
for (n = 0; n < nrParticles; n++) {
    p = initParticle(&params);
    distrNr = 0;
    addPosition(distrs->distr[distrNr], p);
    for (step = 1; step <= maxSteps; step++) {
        move(p, &params);
        if (step % deltaSteps == 0)
            addPosition(distrs->distr[step/deltaSteps], p);
    }
    freeParticle(p);
}
