using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DragonController : MonoBehaviour
{
	[SerializeField] Rigidbody leftWing;
	[SerializeField] Rigidbody rightWing;
	[SerializeField] Transform leftForcePoint;
	[SerializeField] Transform rightForcePoint;
	[SerializeField] Transform leftWingTip;
	[SerializeField] Transform rightWingTip;
	[SerializeField] Transform tailTip;
	[SerializeField] float wingTorque = 1f;
	[SerializeField] float maxWingForce = 5f;
	[SerializeField] float tailPosScale = .1f;
	[SerializeField] float tailForce = 4f;
	[SerializeField] float forwardForce = 5f;
	[SerializeField] GameObject deathParticles;

	private Rigidbody rb;
	private Vector3 prevMousePosition;
	private Vector3 prevLeftWingPosition;
	private Vector3 prevRightWingPosition;
	private float distance = 0f;

	private void Awake()
	{
		rb = GetComponent<Rigidbody>();
		prevMousePosition = Input.mousePosition;
		prevLeftWingPosition = leftWingTip.position;
		prevRightWingPosition = rightWingTip.position;
	}

	private void Update()
	{
		if (Input.GetKey(KeyCode.Q))
			leftWing.AddTorque(transform.forward * -wingTorque);
		if (Input.GetKey(KeyCode.A))
			leftWing.AddTorque(transform.forward * wingTorque);
		if (Input.GetKey(KeyCode.E))
			rightWing.AddTorque(transform.forward * wingTorque);
		if (Input.GetKey(KeyCode.D))
			rightWing.AddTorque(transform.forward * -wingTorque);



		if (Input.GetKey(KeyCode.A))
		{
			float leftWingForce = -Mathf.Clamp(transform.InverseTransformVector(leftWingTip.position - prevLeftWingPosition).y, -maxWingForce, 0f);
			rb.AddForceAtPosition(transform.up * leftWingForce * maxWingForce, rb.worldCenterOfMass + transform.right * -1f);
		}

		if (Input.GetKey(KeyCode.D))
		{
			float rightWingForce = -Mathf.Clamp(transform.InverseTransformVector(rightWingTip.position - prevRightWingPosition).y, -maxWingForce, 0f);
			rb.AddForceAtPosition(transform.up * rightWingForce * maxWingForce, rb.worldCenterOfMass + transform.right * 1f);
		}

		/*if (Input.GetMouseButton(0))
			tailTip.localPosition += (Input.mousePosition - prevMousePosition) * tailPosScale;

		Vector3 v = Vector3.ClampMagnitude(tailTip.localPosition, 2f);
		v.z = -7f;
		tailTip.localPosition = v;
		rb.AddForceAtPosition(-transform.InverseTransformDirection(new Vector3(tailTip.localPosition.x, tailTip.localPosition.y, 0f)) * tailForce, transform.position + transform.forward * -1f);*/

		rb.AddForce(transform.forward * forwardForce);

		prevMousePosition = Input.mousePosition;
		prevLeftWingPosition = leftWingTip.position;
		prevRightWingPosition = rightWingTip.position;

		if (transform.position.z > distance)
		{
			distance = transform.position.z;
			GameManager.Instance.UpdateDistance(distance);
		}
		if (distance > 450f)
		{
			GameManager.Instance.OnWin();
			Destroy(gameObject);
		}
	}

	private void OnCollisionEnter(Collision collision)
	{
		GameManager.Instance.OnPlayerKilled();
		Instantiate(deathParticles, transform.position, transform.rotation);
		Destroy(gameObject);
	}
}
