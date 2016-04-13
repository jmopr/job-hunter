var Jobs = React.createClass({
  propTypes: {
    title: React.PropTypes.string
  },

  render: function() {
    return (
      <div>
        <div>Title: {this.props.title}</div>
        <div>Description: {this.props.description}</div>
      </div>
    );
  }
});
