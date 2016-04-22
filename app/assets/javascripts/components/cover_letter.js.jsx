var CoverPage = React.createClass({
  render: function() {
    return (
      <div className="container jobs-container">
        <NavBar user = {this.props.user} job = {this.props.job}/>
        <CoverBox job = {this.props.job} number = {this.props.number} user = {this.props.user} />
      </div>
    );
  }
})

var contact_method = function(number){
  var d = new Date();
  if(8 < d.getHours() && d.getHours()< 20){
    return "You can call me at " + number + " right now."
  }else{
    return "You can e-mail me by clicking the \"Let's talk!\" button below."
  }
}

var NavBar = React.createClass({
  render: function() {
    return (
      <div>
        <div className="header clearfix">
          <nav>
            <ul className="nav nav-pills pull-right">
              <li role="presentation"><a href="#" target="_blank">About</a></li>
              <li role="presentation"><a href="https://github.com/jmopr/job-hunter" target="_blank">Source Code</a></li>
              <li role="presentation"><a href={"mailto:" + this.props.user.email + "?subject=" + this.props.job.company + " wants to talk"}>Contact</a></li>
            </ul>
          </nav>
          <h3 className="text-muted">The Job-Hunter</h3>
        </div>
        <hr></hr>
      </div>
    );
  }
})

var CoverBox = React.createClass({
  render: function(){
    return(
      <div className="jumbotron">
        <div id="profile-pic">
          <h1 id="hello">Hello, {this.props.job.company}!</h1>
        </div>
        <div className="center-internal">
          <img src={this.props.job.logo} alt="Logo"/>
        </div>
        <div className="row grid-of-stats text-center">
          <div className="col-md-5 loc">
            <div id="number-lines" ></div>
            <span>Lines of Ruby written</span>
            <div className="cavs">(approximately)</div>
          </div>
          <div className="col-md-5 loc">
            <div id="number-projects"></div>
            <span>Github Projects</span>
          </div>
        </div>
        <div className = "row">
          <div className="col-md-6 col-md-offset-3 match text-center">
            <div id="progressbar"></div>
            <div>Percentage Match</div>
            <div className="cavs">based on Algorithm</div>
          </div>
        </div>
        <div className="clearfix"></div>
        <p>
          Hi!
        </p>
        <p className= "text-justify" id="body-paragraph">I'm happy that you're reading this. I think it would be awesome to work at <strong>{this.props.job.company}</strong> as a <strong>{this.props.job.title}</strong>. We should really talk about the job you posted <a href={this.props.job.url}target="_blank">here</a>. {contact_method(this.props.user.phone_number)}</p>
      <p>
        Thanks again,<br></br>
      {this.props.user.first_name} {this.props.user.last_name}
    </p>
    <p>
      <a className="btn btn-lg btn-success btn-block" href={"mailto:" + this.props.user.email + "?subject=" + this.props.job.company + " wants to talk"} role="button">Let's talk!</a>
    </p>
  </div>
);
}
})
