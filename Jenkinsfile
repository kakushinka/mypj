#!groovy
import groovy.json.JsonSlurperClassic
node {
    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.SF_USERNAME
    def SERVER_KEY_CREDENTIALS_ID=env.SERVER_KEY_CREDENTIALS_ID
    def DEPLOYDIR='force-app'
    def TEST_LEVEL='RunLocalTests'
    def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://test.salesforce.com"
    def toolbelt = tool 'sfdxtool'
	def SFDC_USERNAME
    // -------------------------------------------------------------------------
    // Check out code from source control
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
    }
    // -------------------------------------------------------------------------
    // Run all the enclosed stages with access to the Salesforce
    // JWT key credentials.
    // -------------------------------------------------------------------------

 	withEnv(["HOME=${env.WORKSPACE}"]) {	
	
	    withCredentials([file(credentialsId: SERVER_KEY_CREDENTIALS_ID, variable: 'server_key_file')]) {
		// -------------------------------------------------------------------------
		// Authenticate to Salesforce using the server key.
		// -------------------------------------------------------------------------

		stage('Authorize to Salesforce') {
			/*if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --instanceurl ${SF_INSTANCE_URL}"
            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile \"${server_key_file}\" --setdefaultdevhubusername --instanceurl ${SF_INSTANCE_URL}"
            }*/            
			//rc = command "${toolbelt}/sfdx force:auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --jwtkeyfile C:/PJ/certificates/server.key --username ${SF_USERNAME} --setdefaultusername"
            rc = command "\"${toolbelt}\"/sfdx force:auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --jwtkeyfile \"${server_key_file}\" --username ${SF_USERNAME} --setdefaultusername"

			if (rc != 0) {
			error 'Salesforce org authorization failed.'
		    }

            /*def rmsg = bat(returnStdout: true, script:"${toolbelt}/sfdx force:org:create --definitionfile config/project-scratch-def.json --json --setdefaultusername")
			println("stdout ################ " + rmsg + " ####################")
            def robj = new JsonSlurperClassic().parseText(rmsg)
            println("stdout ################ " + rmsg + " ####################")
			if (robj.status != 0) { error 'org creation failed: ' + robj.message }
            println("stdout ################ " + rmsg + " ####################")
			SFDC_USERNAME=robj.result.username
            println("stdout ################ " + rmsg + " ####################")
			robj = null
            */
		}

		stage('Push To Test Org') {
            rc = command "${toolbelt}/sfdx force:source:push -f --targetusername ${SF_USERNAME}"
            if (rc != 0) {
                error 'push failed'
            }
        }


	    }
	}
}

def command(script) {
    if (isUnix()) {
        return sh(returnStatus: true, script: script);
    } else {
		return bat(returnStatus: true, script: script);
    }
}
