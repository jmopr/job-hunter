var word = function(score){if(score >= 75){return "excellent"}else if (score >= 65){
return "great"}else if (score >= 50) { return "good"}else{return "interesting"}}

var CoverLetter = React.createClass({
  render: function() {
    return <div>
      <h1>{this.props.job.title}</h1>
      <h2>at {this.props.job.company} </h2>
      <img src={this.props.job.logo} alt="Logo"/>
      <div>
        Hey! Thanks for taking the time to review my application.
        I actually wrote a script to automatically apply to your job because it looks like it's a {word(this.props.job.score)} fit for my skills - my matching algorithm actually said there is a {this.props.job.score} % percent
        chance you'd be interested in interviewing me. You can check out the match profile I created for your job posting here: url_for_analysis
        I'd really love the opportunity to interview at {this.props.job.company} for the open {this.props.job.title} position. Thanks again. You can reach me at phone_number if you'd like to chat
        P.S. if you're interested in how my bot is actually handling applications for me, you can check out the source code that applied on github: "https://github.com/jmopr/job-hunter".
      </div>
      </div>
  }
});
