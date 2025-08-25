public with sharing class StripeWebhookQueueable implements Queueable, Finalizer {
  IStripeWebhookStrategy strategy;
  String requestBody;
  Integer attemptCount;

  public StripeWebhookQueueable(
    IStripeWebhookStrategy strategy,
    String requestBody
  ) {
    this.strategy = strategy;
    this.requestBody = requestBody;
    this.attemptCount = 1;
  }

  // Constructor for retry attempts
  public StripeWebhookQueueable(
    IStripeWebhookStrategy strategy,
    String requestBody,
    Integer attemptCounter
  ) {
    {
      this.strategy = strategy;
      this.requestBody = requestBody;
      this.attemptCount = attemptCounter;
    }
  }

  //Queueable implementation
  public void execute(QueueableContext qc) {
    String jobId = '' + qc.getJobId();
    Logger.info('Begin: executing queueable job: ' + jobId);

    // Attach finalizer with same parameters
    System.attachFinalizer(
      new StripeWebhookQueueable(
        this.strategy,
        this.requestBody,
        this.attemptCount
      )
    );

    // If this throws, Salesforce will retry once automatically
    strategy.handle(requestBody);

    Logger.info('Completed: execution of job: ' + jobId);
  }

  // Finalizer implementation

  public void execute(FinalizerContext ctx) {
    String parentJobId = '' + ctx.getAsyncApexJobId();
    Logger.info(
      'Begin: executing finalizer attached for queueable job: ' + parentJobId
    );

    if (ctx.getResult() == ParentJobResult.SUCCESS) {
      Logger.info(
        'Parent queueable job [' + parentJobId + '] completed successfully.'
      );
    } else {
      Logger.error(
        'Parent queueable job [' +
          parentJobId +
          '] failed due to unhandled exception: ' +
          ctx.getException().getMessage()
      );

      // Retry up to 5 attempts
      if (attemptCount < 5) {
        Integer nextAttempt = attemptCount + 1;
        Logger.info('Retrying attempt ' + nextAttempt + '...');
        String newJobId = System.enqueueJob(
          new StripeWebhookQueueable(
            this.strategy,
            this.requestBody,
            nextAttempt
          )
        );
        Logger.info('Enqueued new job: ' + newJobId);
      } else {
        Logger.error('Max attempts reached (5). No further retries.');
      }

      Logger.info('Completed: finalizer for job: ' + parentJobId);
    }
  }

  public class StripeWebhookQueueableException extends Exception {
  }
}
