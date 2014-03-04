class CreateDefaultEmailTemplateTypes < ActiveRecord::Migration
  def up


    EmailTemplateType.create({
         type_name: "accept_notification_email",
         title: "Appeal Accept Notification Email",
         default_subject: "[{{conference.name}}] {{ topic.subject }} is accepted",
         default_body: "Your application is accepted for {{ appeal.conference.name }} <br /><br/>
                <b>Speakers:</b> <br/>
                <ul>
                 {% for speaker in appeal.speakers %}

                      <li> {{ speaker.name }}</li>
                 {% endfor %}
                </ul>
                <b>Topic:</b>  {{ appeal.topic.subject }} <br/>
                <b>Details: </b>{{ appeal.topic.detail }} <br/>
                <b>Additional Info:</b> {{ appeal.topic.additional_info }} <br/> <br/>

                <br/><br/>

                -ConfDeck"
    })

    EmailTemplateType.create({
         type_name: "reject_notification_email",
         title: "Appeal Reject Notification Email",
         default_subject: "[{{conference.name}}] {{ topic.subject }} is rejected",
         default_body: "Your application is rejected for {{ appeal.conference.name }} <br /><br/>
            <b>Speakers:</b> <br/>
            <ul>
             {% for speaker in appeal.speakers %}

                  <li> {{ speaker.name }}</li>
             {% endfor %}
            </ul>
            <b>Topic:</b>  {{ appeal.topic.subject }} <br/>
            <b>Details: </b>{{ appeal.topic.detail }} <br/>
            <b>Additional Info:</b> {{ appeal.topic.additional_info }} <br/> <br/>

            <br/><br/>

            -ConfDeck"
    })

    EmailTemplateType.create({
         type_name: "speaker_notification_email",
         title: "Speaker Notification Email",
         default_subject: "[{{conference.name}}] {{ topic.subject }} is received",
         default_body: "Your application is received for {{ appeal.conference.name }} <br /><br/>
            <b>Speakers:</b> <br/>
            <ul>
             {% for speaker in appeal.speakers %}

                  <li> {{ speaker.name }}</li>
             {% endfor %}
            </ul>
            <b>Topic:</b>  {{ appeal.topic.subject }} <br/>
            <b>Details: </b>{{ appeal.topic.detail }} <br/>
            <b>Additional Info:</b> {{ appeal.topic.additional_info }} <br/> <br/>

            <br/><br/>

            -ConfDeck"
    })

    EmailTemplateType.create({
         type_name: "committee_notification_email",
         title: "New Application Notification Email To Committee",
         default_subject: "[{{conference.name}}] New application is received",
         default_body: "New application is received for {{ appeal.conference.name }} <br /><br/>
            <b>Speakers:</b> <br/>
            <ul>
             {% for speaker in appeal.speakers %}

                  <li> {{ speaker.name }}</li>
             {% endfor %}
            </ul>
            <b>Topic:</b>  {{ appeal.topic.subject }} <br/>
            <b>Details: </b>{{ appeal.topic.detail }} <br/>
            <b>Additional Info:</b> {{ appeal.topic.additional_info }} <br/> <br/>

            <br/><br/>

            -ConfDeck"
    })


  end

  def down
    EmailTemplateType.delete_all
  end
end
