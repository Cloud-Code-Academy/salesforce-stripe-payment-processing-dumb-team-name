public with sharing class StripeWebhookQueueable implements Queueable, Finalizer {
  IStripeWebhookStrategy strategy;
  String requestBody;


  public StripeWebhookQueueable(
    IStripeWebhookStrategy strategy,
    String requestBody
  ) {
    this.strategy = strategy;
    this.requestBody = requestBody;
  }

  //Queueable implementation
  public void execute(QueueableContext qc) {
    String jobId = '' + qc.getJobId();
    Logger.info('Begin: executing queueable job: ' + jobId);


    try {
      // Attach finalizer with same parameters
      System.attachFinalizer(
        new StripeWebhookQueueable(this.strategy, this.requestBody)
      );

      strategy.handle(requestBody);
    } catch (Exception e) {
      Logger.error(
        'Error executing the job: [' + jobId + ']: ' + e.getMessage()
      );
    } finally {
      Logger.info('Completed: execution of job: ' + jobId);
    }

    // TODO: Review what Justin did in class on Tuesday, Aug 19, to chain the queueable until all records are processed, and do I need to worry about stack depth
  }


  // Finalizer implementation

  public void execute(FinalizerContext ctx) {
    String parentJobId = '' + ctx.getAsyncApexJobId();
    Logger.info(
      'Begin: executing finalizer attached to queueable job: ' + parentJobId
    );


    if (ctx.getResult() == ParentJobResult.SUCCESS) {
      System.debug(
        'Parent queueable job [' + parentJobId + '] completed successfully.'
      );
    } else {
      Logger.error(
        'Parent queueable job [' +
          parentJobId +
          '] failed due to unhandled exception: ' +
          ctx.getException().getMessage()
      );
      Logger.info('Enqueueing another instance of the queueable...');
      String newJobId = System.enqueueJob(
        new StripeWebhookQueueable(this.strategy, this.requestBody)
      ); // This call fails after 5 times when it hits the chaining limit
      Logger.info('Enqueued new job: ' + newJobId);
    }
    System.debug(
      'Completed: execution of finalizer attached to queueable job: ' +
      parentJobId
    );
  }
}
